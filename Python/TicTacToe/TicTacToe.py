board = [str(i) for i in range(1,10)]
x_mark = "X"
o_mark = "O"
current = x_mark

def draw_board():
	print(f" {board[0]} | {board[1]} | {board[2]}")
	print("---+---+---")
	print(f" {board[3]} | {board[4]} | {board[5]}")
	print("---+---+---")
	print(f" {board[6]} | {board[7]} | {board[8]}\n")

def check_win():
	wins = [
		(0,1,2),(3,4,5),(6,7,8),
		(0,3,6),(1,4,7),(2,5,8),
		(0,4,8),(2,4,6)
	]

	return any(board[a]==board[b]==board[c] for a,b,c in wins)

def is_draw():
	return all(s in (x_mark,o_mark) for s in board)

while True:
	draw_board()
	move = input(f"Player {current}, choose 1-9: ")

	if not move.isdigit() or not 1 <= int(move) <= 9:
		continue

	idx = int(move)-1

	if board[idx] in (x_mark,o_mark):
		continue

	board[idx] = current

	if check_win():
		draw_board()
		print(f"Player {current} wins!")
		break

	if is_draw():
		draw_board()
		print("It's a draw!")
		break

	current = o_mark if (current == x_mark) else x_mark