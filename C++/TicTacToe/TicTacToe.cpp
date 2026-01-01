#include <iostream>
using namespace std;

char board[9] = {'1','2','3','4','5','6','7','8','9'};
char x_mark = 'X', o_mark = 'O';
char current = x_mark;

void drawBoard () {
	system ("clear"); // use "cls" on Windows
	cout << " " << board[0] << " │ " << board[1] << " │ " << board[2] << "\n";
	cout << "───┼───┼───\n";
	cout << " " << board[3] << " │ " << board[4] << " │ " << board[5] << "\n";
	cout << "───┼───┼───\n";
	cout << " " << board[6] << " │ " << board[7] << " │ " << board[8] << "\n\n";
}

// Check all 8 winning combos
bool checkWin () {
	int wins[8][3] = {
		{0,1,2},{3,4,5},{6,7,8},
		{0,3,6},{1,4,7},{2,5,8},
		{0,4,8},{2,4,6}
	};

	for (auto &w : wins) {
		if (board[w[0]] == board[w[1]] && board[w[1]] == board[w[2]])
			return true;
	}

	return false;
}

bool isDraw () {
	for (char c : board)
		if (c != x_mark && c != o_mark)
			return false;

	return true;
}

int main () {
	while (true) {
		drawBoard ();
		cout << "Player " << current << ", enter a position (1-9): ";

		int pos;
		cin >> pos;

		if (pos < 1 || pos > 9)
			cout << "Invalid input!"
			continue;

		if (board[pos-1] == x_mark || board[pos-1] == o_mark)
			cout << "Spot taken! Choose another.";
			continue;

		board[pos-1] = current;

		if (checkWin ()) {
			drawBoard();
			cout << "Player " << current << " wins!\n";
			break;
		}

		if (isDraw ()) {
			drawBoard ();
			cout << "It's a draw!\n";
			break;
		}

		current = (current == x_mark) ? o_mark : x_mark;
	}
	return 0;
}
