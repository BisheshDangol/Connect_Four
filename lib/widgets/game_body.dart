import 'package:connect4_flutter/utilities/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class GameBody extends StatelessWidget {
  const GameBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context, listen: false);
    board.createBoard();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF006DD8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: ColumnValues(context),
            ),
          ),
        ),
        Column(
          children: [
            board.aiWin || board.playerWin
                ? board.aiWin
                    ? const Text("AI Wins")
                    : const Text("Player Wins")
                : Container(),
            board.gameOver
                ? const Text(
                    "Game Over",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                : board.turn == board.playerTurn
                    ? const Text(
                        "Player's Turn",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "AI's Turn",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {
            print("reset");
            Phoenix.rebirth(context);
          },
          child: Text("Reset"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.white70),
          ),
        )
      ],
    );
  }

  List<Widget> ColumnValues(BuildContext context) {
    List<Widget> columnList = [];
    for (int i = 0; i < 6; i++) {
      columnList.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: RowValues(context, i),
      ));
    }
    return columnList;
  }

  List<Widget> RowValues(BuildContext context, int index) {
    final board = Provider.of<Board>(context);
    List<Widget> rowList = [];
    for (int i = 0; i < 7; i++) {
      if (board.printBoard(board.board)[index][i].toInt() == 0) {
        rowList.add(GestureDetector(
          onTap: () {
            if (!board.gameOver) {
              if (board.turn == board.playerTurn) {
                board.playerMakeMove(index, i);
              }
            }
          },
          child: Container(
            margin: EdgeInsets.all(10),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ));
      } else if (board.printBoard(board.board)[index][i].toInt() == 1) {
        rowList.add(GestureDetector(
          onTap: () {
            board.playerMakeMove(index, i);
          },
          child: coinContainer(
              outerColor: const Color(0xFFF00000),
              innerColor: const Color(0xFFDD0000)),
        ));
      } else if (board.printBoard(board.board)[index][i].toInt() == 2) {
        rowList.add(GestureDetector(
          onTap: () {
            board.playerMakeMove(index, i);
          },
          child: coinContainer(
            outerColor: const Color(0xFFEEEE00),
            innerColor: const Color(0xFFD0D000),
          ),
        ));
      }
    }
    return rowList;
  }

  /// Creates a Container for a coin that takes two values of Color [innerColor] and [outerColor]
  Container coinContainer(
      {required Color outerColor, required Color innerColor}) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: outerColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: innerColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  spreadRadius: -0.5,
                  blurRadius: 1,
                )
              ]),
        ),
      ),
    );
  }
}
