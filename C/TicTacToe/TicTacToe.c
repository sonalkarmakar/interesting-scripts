#include <stdio.h>
#include <stdlib.h>

#define PLAYER 'X'
#define COMPUTER 'O'

char board[3][3];  // Game board

// Function prototypes
void initializeBoard();
void printBoard();
int isBoardFull();
int isWinner(char player);
int minimax(int depth, int isMax);
int bestMove();
void makeMove(int row, int col, char player);
int getUserMove();
void playGame();

int main() {
    char firstPlayer;
    printf("Welcome to Tic-Tac-Toe!\n");
    printf("Do you want to play first (X) or second (O)? (X/O): ");
    scanf(" %c", &firstPlayer);

    // Initialize the board
    initializeBoard();

    if (firstPlayer == 'X' || firstPlayer == 'x') {
        // Player goes first
        playGame();
    } else if (firstPlayer == 'O' || firstPlayer == 'o') {
        // Computer goes first
        printf("Computer goes first.\n");
        // Make computer's first move
        int move = bestMove();
        makeMove(move / 3, move % 3, COMPUTER);
        printBoard();
        playGame();
    } else {
        printf("Invalid input. Please restart the game.\n");
    }

    return 0;
}

// Initialize the game board with empty spaces
void initializeBoard() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            board[i][j] = ' ';
        }
    }
}

// Print the current state of the board
void printBoard() {
    printf("\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                printf(" %d ", i * 3 + j + 1);  // Show the cell number if empty
            } else {
                printf(" %c ", board[i][j]);
            }
            if (j < 2) {
                printf("|");
            }
        }
        printf("\n");
        if (i < 2) {
            printf("---|---|---\n");
        }
    }
    printf("\n");
}

// Check if the board is full (no more moves can be made)
int isBoardFull() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                return 0;  // Found an empty spot
            }
        }
    }
    return 1;  // No empty spots left
}

// Check if a player has won
int isWinner(char player) {
    for (int i = 0; i < 3; i++) {
        // Check rows and columns
        if ((board[i][0] == player && board[i][1] == player && board[i][2] == player) ||
            (board[0][i] == player && board[1][i] == player && board[2][i] == player)) {
            return 1;
        }
    }
    // Check diagonals
    if ((board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
        (board[0][2] == player && board[1][1] == player && board[2][0] == player)) {
        return 1;
    }
    return 0;
}

// Minimax algorithm to find the optimal move for the computer
int minimax(int depth, int isMax) {
    if (isWinner(COMPUTER)) {
        return 10 - depth;
    }
    if (isWinner(PLAYER)) {
        return depth - 10;
    }
    if (isBoardFull()) {
        return 0;
    }

    if (isMax) {
        int best = -1000;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == ' ') {
                    board[i][j] = COMPUTER;
                    best = (best > minimax(depth + 1, 0)) ? best : minimax(depth + 1, 0);
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    } else {
        int best = 1000;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == ' ') {
                    board[i][j] = PLAYER;
                    best = (best < minimax(depth + 1, 1)) ? best : minimax(depth + 1, 1);
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    }
}

// Find the best move for the computer
int bestMove() {
    int bestVal = -1000;
    int move = -1;

    // Try every possible move for the computer
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                board[i][j] = COMPUTER;
                int moveVal = minimax(0, 0);
                board[i][j] = ' ';
                if (moveVal > bestVal) {
                    move = i * 3 + j;
                    bestVal = moveVal;
                }
            }
        }
    }
    return move;
}

// Make a move on the board
void makeMove(int row, int col, char player) {
    board[row][col] = player;
}

// Get the user's move
int getUserMove() {
    int move;
    printf("Enter your move (1-9): ");
    scanf("%d", &move);
    return move - 1;
}

// Play the game with the user and the computer
void playGame() {
    int move;
    while (1) {
        printBoard();

        // Player's move
        if (!isBoardFull() && !isWinner(COMPUTER)) {
            move = getUserMove();
            if (board[move / 3][move % 3] == ' ') {
                makeMove(move / 3, move % 3, PLAYER);
            } else {
                printf("Invalid move. Try again.\n");
                continue;
            }
        }

        if (isWinner(PLAYER)) {
            printBoard();
            printf("Congratulations! You won!\n");
            break;
        }

        if (isBoardFull()) {
            printBoard();
            printf("It's a tie!\n");
            break;
        }

        // Computer's move
        if (!isBoardFull() && !isWinner(PLAYER)) {
            printf("Computer is making its move...\n");
            move = bestMove();
            makeMove(move / 3, move % 3, COMPUTER);
        }

        if (isWinner(COMPUTER)) {
            printBoard();
            printf("Computer wins! Better luck next time.\n");
            break;
        }
    }
}
