#!/usr/bin/env bash

# ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
# │ SCRIPT NAME		: AutomatedBackup.sh															│
# │ ARGUMENTS		: None																			│
# │ VERSION			: 1.0.0																			│
# │ LAST REVISION	: 2 Oct 2025																	│
# │ AUTHOR			: Sonal Karmakar																│
# ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
# │ DESCRIPTION		: This script has the following functions--										│
# │ 				  (1) Create a backup copy of a specified directory inside a remote server.		│
# │ 				  (2) Retain a specifed number of backups and delete copies older than that.	│
# │ 				  (3) Generate logs and reports of the backup to store inside the host system. 	│
# │ 				  (4) [Optional] Email the report to a specifed email address.					│
# ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
# │ PREREQUISITES	: (1) OpenSSH installed and configured in both host and remote systems.			│
# │ 				  (2) [Optional] Host system is configured for password-less SSH connection.	│
# │ 				  (3) Remote system has a user created specifically for this purpose.			│
# │ 				  (4) [Optional] Mailing service is installed for emailing the reports.			│
# └─────────────────────────────────────────────────────────────────────────────────────────────────┘

# ──┤ CONFIGURATION ├──────────────────────────────────────────────────────────────────────────────

# Local directory to back up (source)
SRC_DIR="$HOME"

# Remote server settings
REMOTE_USER="backup_user"
REMOTE_HOST="10.11.12.13"						# add remote server's IP address or hostname
REMOTE_PORT=22									# change if using non‑standard SSH port
REMOTE_BASE_DIR="/home/$REMOTE_USER/Backups"	# remote base path

# Additional rsync options
RSYNC_OPTS="-avz --delete"

# Log / report
LOG_AND_REPORT_DIR="$HOME/AutomatedBackupScript"
LOG_DIR="$LOG_AND_REPORT_DIR/logs/"
LOG_FILE="$LOG_DIR/backup-$(date +%Y%b%d_%H%M%S).log"
REPORT_DIR="$LOG_AND_REPORT_DIR/reports"
REPORT_FILE="$REPORT_DIR/backup_report_$(date +%Y%b%d_%H%M%S).txt"

# Max number of backups to keep (optional)
MAX_BACKUPS=7

# ──┤ HELPER / SETUP ├─────────────────────────────────────────────────────────────────────────────

mkdir -p "$LOG_DIR" "$REPORT_DIR"

function die() {
	echo "[ERROR] $*" | tee -a "$LOG_FILE"
	exit 1
}

function info() {
	echo "[INFO] $*" | tee -a "$LOG_FILE"
}

# Check that source directory exists
if [ ! -d "$SRC_DIR" ]; then
	die "Source directory \"$SRC_DIR\" does not exist."
fi

# ──┤ PERFORM BACKUP ├─────────────────────────────────────────────────────────────────────────────

TIMESTAMP=$(date +%Y%b%d_%H%M%S)
PREFIX="backup"	# prefix for all backup directories that will be created
REMOTE_DEST="$REMOTE_BASE_DIR/${PREFIX}_$TIMESTAMP"

info "Starting backup of $SRC_DIR to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"

# Run rsync over SSH
# The -e option lets you specify ssh and port
rsync -e "ssh -p $REMOTE_PORT" $RSYNC_OPTS "$SRC_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST" 2>&1 | tee -a "$LOG_FILE"
RSYNC_EXIT=${PIPESTATUS[0]}

if [ $RSYNC_EXIT -ne 0 ]; then
	echo "Backup failed with rsync exit code $RSYNC_EXIT" | tee -a "$LOG_FILE"
	STATUS="FAILURE"
else
	info "rsync completed with exit code 0"

	# (Optional) Verify by listing remote directory or checking file counts
	ssh -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "ls -l $REMOTE_DEST" >> "$LOG_FILE" 2>&1
	if [ $? -eq 0 ]; then
		info "Verified remote directory listing succeeded."
		STATUS="SUCCESS"
	else
		echo "Warning: Could not verify remote directory listing" | tee -a "$LOG_FILE"
		STATUS="WARNING"
	fi
fi

# Apply read, write and execute permissions for all backup copies
ssh -p ssh -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "chmod -R +rwx \"$REMOTE_BASE_DIR\""

# ──┤ CLEANUP OLD BACKUPS (Optional) ├─────────────────────────────────────────────────────────────

info "Pruning old backups, keeping at most $MAX_BACKUPS versions"
#ssh -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "echo \"\" > \"$REMOTE_BASE_DIR/testcheck.txt\""

ssh -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "
ls -1d $REMOTE_BASE_DIR/${PREFIX}_*/ | head -n -$MAX_BACKUPS | \
	while read old; do
		rm -rf \"\$old\"
	done
" >> "$LOG_FILE" 2>&1 || info "Pruning may have encountered errors"

# ──┤ GENERATE REPORT ├────────────────────────────────────────────────────────────────────────────

{
	echo "Backup Report"
	echo "Date: $(date +"%d-%b-%Y %T %Z")"
	echo "Source: $SRC_DIR"
	echo "Destination: $REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"
	echo "Status: $STATUS"
	echo
	echo "Recent log tail:"
	tail -n 20 "$LOG_FILE"
} > "$REPORT_FILE"

info "Report written to $REPORT_FILE"

# Optionally, you could mail the report:
# mail -s "Backup Report ($STATUS)" admin@example.com < "$REPORT_FILE"

# Exit with appropriate status
if [ "$STATUS" = "SUCCESS" ]; then
	exit 0
else
	exit 1
fi