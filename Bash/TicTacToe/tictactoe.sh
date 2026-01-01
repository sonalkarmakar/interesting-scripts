#!/usr/bin/env bash

board=(1 2 3 4 5 6 7 8 9)
x_mark='X'
o_mark='O'

print_board() {
	clear
	echo " ${board[0]} │ ${board[1]} │ ${board[2]} "
	echo "───┼───┼───"
	echo " ${board[3]} │ ${board[4]} │ ${board[5]} "
	echo "───┼───┼───"
	echo " ${board[6]} │ ${board[7]} │ ${board[8]} "
	echo
}

check_win() {
	local wins=(0 1 2 3 4 5 6 7)
	# Check all win combos
	if [[ ${board[0]} == ${board[1]} && ${board[1]} == ${board[2]} ]] ||
		[[ ${board[3]} == ${board[4]} && ${board[4]} == ${board[5]} ]] ||
		[[ ${board[6]} == ${board[7]} && ${board[7]} == ${board[8]} ]] ||
		[[ ${board[0]} == ${board[3]} && ${board[3]} == ${board[6]} ]] ||
		[[ ${board[1]} == ${board[4]} && ${board[4]} == ${board[7]} ]] ||
		[[ ${board[2]} == ${board[5]} && ${board[5]} == ${board[8]} ]] ||
		[[ ${board[0]} == ${board[4]} && ${board[4]} == ${board[8]} ]] ||
		[[ ${board[2]} == ${board[4]} && ${board[4]} == ${board[6]} ]]; then
		return 0
	fi

	return 1
}

check_draw() {
	for i in "${board[@]}"; do
		if [[ "$i" =~ ^[0-9]$ ]]; then
			return 1
		fi
	done

	return 0
}

current=$x_mark
while true; do
	print_board
	read -p "Player $current, choose a spot (1-9): " move

	# Validate input
	if ! [[ "$move" =~ ^[1-9]$ ]]; then
		echo "Invalid! Enter a number 1–9."
		sleep 1
		continue
	fi

	idx=$((move - 1))
	if [[ "${board[$idx]}" == $x_mark || "${board[$idx]}" == $o_mark ]]; then
		echo "Spot taken! Choose another."
		sleep 1
		continue
	fi

	board[$idx]=$current

	# Check for win
	if check_win; then
		print_board
		echo "Player $current wins!"
		break
	fi

	# Check draw
	if check_draw; then
		print_board
		echo "It's a draw!"
		break
	fi

	# Switch player
	if [[ "$current" == $x_mark ]]; then
		current=$o_mark
	else
		current=$x_mark
	fi
done
