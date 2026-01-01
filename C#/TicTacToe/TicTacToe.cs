using System;

class TicTacToe {
	static char[] board = { '1','2','3','4','5','6','7','8','9' };
	static int currentPlayer = 1; // Player 1 = X, Player 2 = O
	static char playerMark, x_mark = 'X', o_mark = 'O';
	static bool gameEnd = false;

	static void Main () {
		do {
			Console.Clear ();
			DrawBoard ();
			PlayerTurn ();
			gameEnd = CheckWin () || CheckDraw ();
			currentPlayer = (currentPlayer == 1) ? 2 : 1;
		} while (!gameEnd);

		Console.Clear ();
		DrawBoard ();
		Console.WriteLine ("Game over. Thanks for playing!");
	}

	static void DrawBoard () {
		Console.WriteLine ("Tic Tac Toe\n");
		Console.WriteLine ($" {board[0]} │ {board[1]} │ {board[2]} ");
		Console.WriteLine ("───┼───┼───");
		Console.WriteLine ($" {board[3]} │ {board[4]} │ {board[5]} ");
		Console.WriteLine ("───┼───┼───");
		Console.WriteLine ($" {board[6]} │ {board[7]} │ {board[8]} ");
		Console.WriteLine ();
	}

	static void PlayerTurn () {
		if (currentPlayer == 1) playerMark = x_mark;
		else playerMark = o_mark;

		Console.Write ($"Player {currentPlayer} ({playerMark}), choose your position (1-9): ");

		bool validInput = false;
		while (!validInput) {
			string input = Console.ReadLine ();
			int choice;

			if (int.TryParse (input, out choice) && choice >= 1 && choice <= 9) {
				if (board[choice - 1] != x_mark && board[choice - 1] != o_mark) {
					board[choice - 1] = playerMark;
					validInput = true;
				}
				else
					Console.Write ("That spot is already taken! Choose another: ");
			}
			else
				Console.Write ("Invalid input! Enter a number 1-9: ");
		}
	}

	static bool CheckWin () {
		int[,] winConditions = new int[,] {
			{0,1,2}, {3,4,5}, {6,7,8}, // rows
			{0,3,6}, {1,4,7}, {2,5,8}, // columns
			{0,4,8}, {2,4,6}           // diagonals
		};

		for (int i = 0; i < winConditions.GetLength(0); i++) {
			int a = winConditions[i, 0];
			int b = winConditions[i, 1];
			int c = winConditions[i, 2];

			if (board[a] == board[b] && board[b] == board[c]) {
				Console.WriteLine ($"\nPlayer {currentPlayer} ({playerMark}) wins!");
				return true;
			}
		}
		return false;
	}

	static bool CheckDraw () {
		foreach (char spot in board) {
			if (spot != x_mark && spot != o_mark)
				return false;
		}
		Console.WriteLine("\nIt's a draw!");
		return true;
	}
}