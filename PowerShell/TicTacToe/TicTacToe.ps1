# Simple Tic-Tac-Toe in PowerShell
$board = @('1','2','3','4','5','6','7','8','9')
$x_mark = 'X'
$o_mark = 'O'
$current = $x_mark

function Draw-Board {
	Clear-Host
	Write-Host " $($board[0]) │ $($board[1]) │ $($board[2])"
	Write-Host "───┼───┼───"
	Write-Host " $($board[3]) │ $($board[4]) │ $($board[5])"
	Write-Host "───┼───┼───"
	Write-Host " $($board[6]) │ $($board[7]) │ $($board[8])"
	Write-Host ""
}

function Check-Win {
	$wins = @( @(0,1,2), @(3,4,5), @(6,7,8),
			@(0,3,6), @(1,4,7), @(2,5,8),
			@(0,4,8), @(2,4,6) )
	foreach ($w in $wins) {
		if ($board[$w[0]] -eq $board[$w[1]] -and $board[$w[1]] -eq $board[$w[2]]) {
			return $true
		}
	}
	return $false
}

function Is-Draw {
	foreach ($c in $board) {
		if ($c -notin $x_mark,$o_mark) { return $false }
	}
	return $true
}

while ($true) {
	Draw-Board
	$move = Read-Host "Player $current, enter 1-9"
	if ($move -notmatch '^[1-9]$') { continue }
	$idx = [int]$move - 1
	if ($board[$idx] -in $x_mark,$o_mark) { continue }
	$board[$idx] = $current

	if (Check-Win) {
		Draw-Board
		Write-Host "Player $current wins!"
		break
	}
	if (Is-Draw) {
		Draw-Board
		Write-Host "It's a draw!"
		break
	}
	$current = if ($current -eq $x_mark) { $o_mark } else { $x_mark }
}