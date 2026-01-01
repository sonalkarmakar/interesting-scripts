#!/usr/bin/env bash

# ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
# │ SCRIPT NAME		: SystemHealthMontor.sh															│
# │ ARGUMENTS		: None																			│
# │ VERSION			: 1.0.0																			│
# │ LAST REVISION	: 2 Oct 2025																	│
# │ AUTHOR			: Sonal Karmakar																│
# ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
# │ DESCRIPTION		: This script has the following functions--										│
# │ 				  (1) Monitor usage of CPU, Memory and Storage and report status.				│
# │ 				  (2) Generate logs and alert when resouce usage crosses specified thresholds.	│
# │ 				  (3) [Optional] Email the report and alerts to a specifed email address.		│
# ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
# │ PREREQUISITES	: (1) Run with higher privileges (sudo).										│
# │ 				  (2) [Optional] Mailing service is installed and configured for				│
# │ 				  emailing alerts and reports.													│
# └─────────────────────────────────────────────────────────────────────────────────────────────────┘

# ──┤ CONFIGURATION ├──────────────────────────────────────────────────────────────────────────────

# Thresholds (in percent)
CPU_THRESHOLD=80	# e.g. alert if CPU usage > 80%
MEM_THRESHOLD=80	# memory usage > 80%
DISK_THRESHOLD=90	# disk usage > 90%

# Which filesystems to monitor (space separated). Use mount points.
MONITORED_DISKS="/ /home /var"

# (Optional) specify specific processes to check (by name or pattern)
# If any process matches and uses more than PROC_CPU_THRESHOLD or PROC_MEM_THRESHOLD, alert
PROC_CHECK_ENABLED=true
PROC_CPU_THRESHOLD=50	# percent CPU per process
PROC_MEM_THRESHOLD=50	# percent mem per process

# Log file
LOGFILE="/var/log/sys_health_monitor.log"

# Interval between checks (in seconds)
INTERVAL=60

# ──┤ FUNCTIONS ├──────────────────────────────────────────────────────────────────────────────────

log_msg() {
	local msg="$1"
	local timestamp
	timestamp=$(date +"[%Y-%b-%d %T]")
	echo "$timestamp $msg" | tee -a "$LOGFILE"
}

# CPU usage (average across all cores)
get_cpu_usage() {
	local cpu_idle cpu_used expr out

	cpu_idle=$(top -bn1 | awk '/Cpu\(s\)/ {
		for (i=1; i<=NF; i++) {
			if ($i ~ /id,?/) {
				# the field before “id,” is the idle value in percent
				print $(i-1)
				break
			}
		}
	}' | sed 's/,/./g')

	# Logging (for debug)
	# echo "DEBUG: cpu_idle='$cpu_idle'" >&2

	# Fallback: if empty or non‑numeric, default to 0 idle
	if [[ -z "$cpu_idle" || ! $cpu_idle =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		cpu_idle=0
	fi

	expr="100.0 - $cpu_idle"
	# echo "DEBUG: expr='$expr'" >&2

	# Perform bc calculation, capture errors
	out=$(echo "$expr" | bc 2>&1)
	if [[ $? -ne 0 || ! $out =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		# If bc fails, fallback to 0 usage or some safe value
		# echo "WARNING: bc failed for expr '$expr', bc output: '$out'" >&2
		cpu_used=0
	else
		cpu_used="$out"
	fi

	echo "$cpu_used"
}

get_mem_usage() {
	# Read memory stats from /proc/meminfo (values in kB)
	local mem_total mem_free buffers cached
	mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
	mem_free=$(awk '/MemFree/ {print $2}' /proc/meminfo)
	buffers=$(awk '/Buffers/ {print $2}' /proc/meminfo)
	cached=$(awk '/^Cached/ {print $2}' /proc/meminfo)

	# Compute “used excluding buffers/cache”
	local used_eff
	used_eff=$(( mem_total - mem_free - buffers - cached ))
	if (( used_eff < 0 )); then
		used_eff=0
	fi

	# Percentage
	# mem_total is in kB, used_eff in kB
	local pct
	pct=$(awk "BEGIN { printf \"%.1f\", ($used_eff * 100) / $mem_total }")

	echo "$pct"
}

# returns disk usage percent (integer) for a mount point
get_disk_usage_for() {
	local mp="$1"
	# Use df, skip the % sign
	local used_pct
	used_pct=$(df -P "$mp" | awk 'NR==2 { gsub("%","",$5); print $5 }')
	echo "$used_pct"
}

check_process_usage() {
	# List processes with CPU or MEM usage above thresholds
	# ps output: PID, %CPU, %MEM, command
	ps -eo pid,pcpu,pmem,cmd --sort=-pcpu | awk -v pc_thresh="$PROC_CPU_THRESHOLD" \
		-v pm_thresh="$PROC_MEM_THRESHOLD" '
	NR>1 {
		if ($2+0 > pc_thresh || $3+0 > pm_thresh) {
			printf("PID=%s CPU=%.1f MEM=%.1f CMD=%s\n", $1, $2, $3, substr($0, index($0,$4)))
		}
	}'
}

# ──┤ MAIN MONITORING LOOP ├───────────────────────────────────────────────────────────────────────

# Ensure log file exists and is writable
touch "$LOGFILE" 2>/dev/null
if [[ ! -w "$LOGFILE" ]]; then
	echo "ERROR: Cannot write to log file $LOGFILE"
	exit 1
fi

log_msg "Starting system health monitor (interval = ${INTERVAL}s)"

while true; do
	# CPU
	cpu_used=$(get_cpu_usage)
	cpu_int=${cpu_used%.*}
	if [[ $cpu_int -ge $CPU_THRESHOLD ]]; then
		log_msg "ALERT: High CPU usage detected: ${cpu_used}% (threshold = ${CPU_THRESHOLD}%)"
	else
		log_msg "OK: CPU usage = ${cpu_used}%"
	fi

	# Memory
	mem_used=$(get_mem_usage)
	mem_int=${mem_used%.*}
	if [[ $mem_int -ge $MEM_THRESHOLD ]]; then
		log_msg "ALERT: High memory usage detected: ${mem_used}% (threshold = ${MEM_THRESHOLD}%)"
	else
		log_msg "OK: Memory usage = ${mem_used}%"
	fi

	# Disk(s)
	for mp in $MONITORED_DISKS; do
		# Check mount point exists
		if mountpoint -q "$mp"; then
			du=$(get_disk_usage_for "$mp")
			if [[ -n "$du" ]] && [[ $du -ge $DISK_THRESHOLD ]]; then
				log_msg "ALERT: High disk usage on ${mp}: ${du}% (threshold = ${DISK_THRESHOLD}%)"
			else
				log_msg "OK: Disk usage on ${mp} = ${du}%"
			fi
		else
			log_msg "WARN: Mount point ${mp} is not valid / not mounted"
		fi
	done

	# Process-level checks
	if $PROC_CHECK_ENABLED; then
		p_alerts=$(check_process_usage)
		if [[ -n "$p_alerts" ]]; then
			log_msg "ALERT: High-usage processes found:"
			while IFS= read -r line; do
				log_msg "    $line"
			done <<< "$p_alerts"
		else
			log_msg "OK: No process above CPU/Memory thresholds"
		fi
	fi

	# Sleep until next check
	sleep "$INTERVAL"
done