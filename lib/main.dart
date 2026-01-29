import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int playerPosition = 1;

  void rollDice() {
    setState(() {
      int dice = (1 + (6 * (DateTime.now().millisecondsSinceEpoch % 6) / 6))
          .floor();
      playerPosition += dice;
      if (playerPosition > 100) playerPosition = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snake and Ladder")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 100,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
              ),
              itemBuilder: (context, index) {
                int cellNumber = 100 - index;
                bool isPlayerHere = cellNumber == playerPosition;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: isPlayerHere ? Colors.red : Colors.green[200],
                  ),
                  child: Center(child: Text(cellNumber.toString())),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: rollDice, child: const Text("Roll Dice")),
        ],
      ),
    );
  }
}
