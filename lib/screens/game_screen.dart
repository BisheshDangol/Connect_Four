import 'package:connect4_flutter/utilities/board.dart';
import 'package:connect4_flutter/widgets/game_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect 4 AI Demonstration'),
      ),
      body: ChangeNotifierProvider<Board>(
        create: (context) => Board(),
        child: const GameBody(),
      ),
    );
  }
}
