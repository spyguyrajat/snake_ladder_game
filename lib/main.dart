import 'package:flutter/material.dart';
import 'dart:math';

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
  //Player Positions
  int player1Position = 1;
  int player2Position = 1;

  //Turn Control
  bool isPlayer1Turn = true;

  //Dice
  final random = Random();
  int currentDice = 1;
  bool isRolling = false;

  Map<int, int> snakeAndLadders = {
    16: 6,
    47: 26,
    49: 11,
    62: 19,
    64: 60,
    87: 24,
    93: 73,
    95: 75,
    98: 78,
    1: 38,
    4: 14,
    9: 31,
    21: 42,
    28: 84,
    36: 44,
    51: 67,
    71: 91,
    80: 100,
  };

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$winner wins!"),
        content: const Text("Congratulations 🎉"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                player1Position = 1;
                player2Position = 1;
                isPlayer1Turn = true;
              });
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  void rollDice() async {
    if (isRolling) return;

    setState(() {
      isRolling = true;
    });

    //Animate dice for 1 sec
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        currentDice = random.nextInt(6) + 1;
      });
    }
    int dice = currentDice;

    setState(() {
      if (isPlayer1Turn) {
        player1Position += dice;
        if (player1Position > 100) player1Position = 100;

        if (snakeAndLadders.containsKey(player1Position)) {
          player1Position = snakeAndLadders[player1Position]!;
        }

        if (player1Position == 100) {
          showWinnerDialog("Player 1");
          return;
        }
      } else {
        player2Position += dice;
        if (player2Position > 100) player2Position = 100;

        if (snakeAndLadders.containsKey(player2Position)) {
          player2Position = snakeAndLadders[player2Position]!;
        }

        if (player2Position == 100) {
          showWinnerDialog("Player 2");
          return;
        }
      }

      isPlayer1Turn = !isPlayer1Turn;
      isRolling = false;
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
                bool isPlayer1Here = cellNumber == player1Position;
                bool isPlayer2Here = cellNumber == player2Position;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.green[200],
                  ),
                  child: Stack(
                    children: [
                      Center(child: Text(cellNumber.toString())),

                      if (isPlayer1Here)
                        const Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                          ),
                        ),

                      if (isPlayer2Here)
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Text(
            isPlayer1Turn ? "Player 1's Turn" : "Player 2's Turn",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return RotationTransition(turns: animation, child: child);
            },
            child: Text(
              currentDice.toString(),
              key: ValueKey(currentDice),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: isRolling ? null : rollDice,
            child: const Text("Roll Dice"),
          ),
        ],
      ),
    );
  }
}
