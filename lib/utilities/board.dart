import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:scidart/numdart.dart';

class Board with ChangeNotifier {
  /// Defining the Row and Columns of the board
  int rowCount = 6;
  int colCount = 7;

  /// Defining the Turn Value for Player and AI
  int playerTurn = 0;
  int aiTurn = 1;

  ///Defining whose cell it is in the board
  int emptyCell = 0;
  int playerCoin = 1;
  int aiCoin = 2;

  /// Defining the no. of cells requried to win
  int winLength = 4;

  /// Defining a flag that denotes if a game has ended
  bool gameOver = false;
  bool playerWin = false;
  bool aiWin = false;

  late Array2d board;
  late int turn;

  /// Initializing the board
  Board() {
    board = createBoard();
    turn = Random().nextInt(2);
    if (turn == aiTurn) {
      aiMakeMove();
    }
  }

  ///Flips the board in X-Axis and returns the flipped board
  Array2d printBoard(board) {
    Array2d printBoard = Array2d.empty();
    for (int i = 5; i >= 0; i--) {
      printBoard.add(Array.empty());
      for (int j = 6; j >= 0; j--) {
        printBoard[5 - i].add(board[i][6 - j]);
      }
    }
    return printBoard;
  }

  void playerMakeMove(int row, int col) {
    if (isValidMove(board, col)) {
      int row = getNextOpenRow(board, col);
      makeMove(board, row, col, playerCoin);

      if (winState(board, playerCoin)) {
        print("Player Wins!");
        playerWin = true;
        gameOver = true;
        notifyListeners();
      }
      turn = aiTurn;
      aiMakeMove();
    } else {
      print("Not Valid Move");
    }
  }

  void aiMakeMove() {
    double col =
        minimax(board, 5, double.negativeInfinity, double.infinity, true)[0]
            .toDouble();
    int row = getNextOpenRow(board, col.toInt());
    makeMove(board, row, col.toInt(), aiCoin);
    if (winState(board, aiCoin)) {
      print("AI Wins!");
      aiWin = true;
      gameOver = true;
      notifyListeners();
    }
    turn = playerTurn;
  }

  Array2d createBoard() {
    var boardMatrix = Array2d.empty();
    for (int i = 0; i < rowCount; i++) {
      boardMatrix.add(Array.empty());
      for (int j = 0; j < colCount; j++) {
        boardMatrix[i].add(emptyCell.toDouble());
      }
    }
    return boardMatrix;
  }

  /// Function that drops the coin into the board
  void makeMove(Array2d board, int row, int col, int piece) {
    board[row][col] = piece.toDouble();
    notifyListeners();
  }

  /// Check if the current move is valid or not
  bool isValidMove(Array2d board, int col) {
    return board[rowCount - 1][col] == emptyCell ? true : false;
  }

  ///Find the next open row in the selected column and return the row index
  int getNextOpenRow(Array2d board, int col) {
    for (int r = 0; r < rowCount.toInt(); r++) {
      if (board[r][col.toInt()] == emptyCell) {
        return r;
      }
    }
    return -1;
  }

  ///Checking the board if it fulfills the win condition
  bool winState(Array2d board, int piece) {
    double currentPiece = piece.toDouble();
    // Check horizontal locations for win
    for (int c = 0; c < colCount - 3; c++) {
      for (int r = 0; r < rowCount; r++) {
        if (board[r][c] == currentPiece &&
            board[r][c + 1] == currentPiece &&
            board[r][c + 2] == currentPiece &&
            board[r][c + 3] == currentPiece) {
          return true;
        }
      }
    }

    // Check vertical locations for win
    for (int c = 0; c < colCount; c++) {
      for (int r = 0; r < rowCount - 3; r++) {
        if (board[r][c] == currentPiece &&
            board[r + 1][c] == currentPiece &&
            board[r + 2][c] == currentPiece &&
            board[r + 3][c] == currentPiece) {
          return true;
        }
      }
    }

    // Check Positively Sloped Diagonal Locations for win
    for (int c = 0; c < colCount - 3; c++) {
      for (int r = 0; r < rowCount - 3; r++) {
        if (board[r][c] == piece &&
            board[r + 1][c + 1] == currentPiece &&
            board[r + 2][c + 2] == currentPiece &&
            board[r + 3][c + 3] == currentPiece) {
          return true;
        }
      }
    }

    //Check Negatively Sloped Diagonal Locations for win
    for (int c = 0; c < colCount - 3; c++) {
      for (int r = 3; r < rowCount; r++) {
        if (board[r][c] == currentPiece &&
            board[r - 1][c + 1] == currentPiece &&
            board[r - 2][c + 2] == currentPiece &&
            board[r - 3][c + 3] == currentPiece) {
          return true;
        }
      }
    }

    // If no winning move is found, return false
    return false;
  }

  ///Evaluates Individual Score for a Window
  int evaluateWindow(List<double> window, piece) {
    int opponentPiece = playerCoin;
    if (piece == playerCoin) {
      opponentPiece = aiCoin;
    }
    //Counting the number of pieces in a window
    int playerCount = 0;
    int opponentPieceCount = 0;
    int emptyCount = 0;
    for (int i = 0; i < window.length; i++) {
      if (window[i] == piece) {
        playerCount++;
      } else if (window[i] == opponentPiece) {
        opponentPieceCount++;
      } else {
        emptyCount++;
      }
    }
    int score = 0;

    if (playerCount == 4) {
      score = score + 100;
    } else if (playerCount == 3 && emptyCount == 1) {
      score = score + 5;
    } else if (playerCount == 2 && emptyCount == 2) {
      score = score + 2;
    }

    if (opponentPieceCount == 3 && emptyCount == 1) {
      score = score - 4;
    }

    return score;
  }

  ///Evaluate the Board Score
  int scorePosition(Array2d board, int piece) {
    int score = 0;

    //Score Center Locations
    for (int i = 0; i < rowCount; i++) {
      if (board[i][3] == piece) {
        score = score + 3;
      }
    }

    //Score Horizontal Locations
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount - 3; c++) {
        List<double> window = [];
        for (int i = 0; i < winLength; i++) {
          window.add(board[r][c + i]);
        }
        score = score + evaluateWindow(window, piece);
      }
    }

    //Score Vertical Locations
    for (int c = 0; c < colCount; c++) {
      for (int r = 0; r < rowCount - 3; r++) {
        List<double> window = [];
        for (int i = 0; i < winLength; i++) {
          window.add(board[r + i][c]);
        }
        score = score + evaluateWindow(window, piece);
      }
    }

    //Score Positively Sloped Diagonal Locations
    for (int r = 0; r < rowCount - 3; r++) {
      for (int c = 0; c < colCount - 3; c++) {
        List<double> window = [];
        for (int i = 0; i < winLength; i++) {
          window.add(board[r + i][c + i]);
        }
        score = score + evaluateWindow(window, piece);
      }
    }

    //Score Negatively Sloped Diagonal Locations
    for (int r = 0; r < rowCount - 3; r++) {
      for (int c = 0; c < colCount - 3; c++) {
        List<double> window = [];
        for (int i = 0; i < winLength; i++) {
          window.add(board[r + 3 - i][c + i]);
        }
        score = score + evaluateWindow(window, piece);
      }
    }

    return score;
  }

  ///Returns a List of all Possible Move Locations in the Current Board State
  List<int> getValidLocations(board) {
    List<int> validLocations = [];
    for (int col = 0; col < colCount; col++) {
      if (isValidMove(board, col)) {
        validLocations.add(col);
      }
    }

    return validLocations;
  }

  ///Making a decision of best move by using the Mini-Max Algorithm with Alpha Beta Pruning
  List minimax(Array2d board, int depth, double alpha, double beta,
      bool maximizingPlayer) {
    List<int> validLocations = getValidLocations(board);
    bool isTerminal = isTerminalNode(board);
    if (depth == 0 || isTerminal) {
      if (isTerminal) {
        if (winState(board, playerCoin)) {
          return [null, double.negativeInfinity];
        } else if (winState(board, aiCoin)) {
          return [null, double.infinity];
        } else {
          return [null, 0];
        }
      } else {
        return [null, scorePosition(board, aiCoin)];
      }
    }

    if (maximizingPlayer) {
      double value = double.negativeInfinity;
      var randomSelection = Random().nextInt(validLocations.length);
      int column = validLocations[randomSelection];
      for (int col in validLocations) {
        int row = getNextOpenRow(board, col);
        Array2d newBoard = board.copy();
        makeMove(newBoard, row, col, aiCoin);
        double newScore =
            minimax(newBoard, depth - 1, alpha, beta, false)[1].toDouble();
        if (newScore > value) {
          value = newScore;
          column = col;
        }
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
      return [column, value];
    } else {
      // Minimizing Player
      double value = double.infinity;
      int column = 0;
      for (int col in validLocations) {
        int row = getNextOpenRow(board, col);
        Array2d newBoard = board.copy();
        makeMove(newBoard, row, col, playerCoin);
        double newScore =
            minimax(newBoard, depth - 1, alpha, beta, true)[1].toDouble();
        if (newScore < value) {
          value = newScore;
          column = col;
        }
        beta = min(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
      return [column, value];
    }
  }

  ///Checking whether the game has ended with a win, loss, or draw
  bool isTerminalNode(board) {
    return winState(board, playerCoin) ||
        winState(board, aiCoin) ||
        getValidLocations(board).isEmpty;
  }
}
