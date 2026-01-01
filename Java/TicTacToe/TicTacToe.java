import java.util.Scanner;

public class TicTacToe
{
	static char[] board = {'1','2','3','4','5','6','7','8','9'};
	static char x_mark = 'X', o_mark = 'O';
	static char current = x_mark;

	public static void main (String[] args)
	{
		Scanner sc = new Scanner (System.in);
		while (true)
		{
			drawBoard ();

			System.out.print ("Player " + current + ", choose (1-9): ");
			int pos = sc.nextInt ();

			if (pos < 1 || pos > 9 || board[pos-1] == x_mark || board[pos-1] == o_mark)
				continue;

			board[pos-1] = current;

			if (checkWin ())
			{
				drawBoard();
				System.out.println("Player " + current + " wins!");
				break;
			}
			if (isDraw ())
			{
				drawBoard();
				System.out.println("It's a draw!");
				break;
			}

			current = (current == x_mark)? o_mark : x_mark;
		}

		sc.close ();
	}

	static void drawBoard ()
	{
		System.out.println (" " + board[0] + " │ " + board[1] + " │ " + board[2]);
		System.out.println ("───┼───┼───");
		System.out.println (" " + board[3] + " │ " + board[4] + " │ " + board[5]);
		System.out.println ("───┼───┼───");
		System.out.println (" " + board[6] + " │ " + board[7] + " │ " + board[8]);
		System.out.println ();
	}

	static boolean checkWin ()
	{
		int[][] winCombos =
		{
			{0,1,2},{3,4,5},{6,7,8},
			{0,3,6},{1,4,7},{2,5,8},
			{0,4,8},{2,4,6}
		};

		for (int[] w : winCombos) {
			if (board[w[0]] == board[w[1]] && board[w[1]] == board[w[2]])
				return true;
		}

		return false;
	}

	static boolean isDraw()
	{
		for (char c : board)
			if (c != x_mark && c != o_mark)
				return false;

		return true;
	}
}