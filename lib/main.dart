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
    // Snakes
    16: 6,
    47: 26,
    49: 11,
    62: 19,
    64: 60,
    87: 24,
    93: 73,
    95: 75,
    98: 78,

    //Ladders
    2: 38,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 100,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10,
                          ),
                      itemBuilder: (context, index) {
                        int row = index ~/ 10;
                        int col = index % 10;

                        if (row.isEven) {
                          col = 9 - col;
                        }

                        int cellNumber = (9 - row) * 10 + col + 1;
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

                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: SnakeLadderPainter(snakeAndLadders),
                    ),
                  ],
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

class SnakeLadderPainter extends CustomPainter {
  final Map<int, int> map;

  SnakeLadderPainter(this.map);

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / 10;

    final ladderPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final snakePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    for (var entry in map.entries) {
      final start = getCellCenter(entry.key, cellSize);
      final end = getCellCenter(entry.value, cellSize);

      if (entry.value > entry.key) {
        // Ladder
        canvas.drawLine(start, end, ladderPaint);
      } else {
        // Snake (curved)
        final path = Path();
        path.moveTo(start.dx, start.dy);

        final midX = (start.dx + end.dx) / 2;
        path.cubicTo(midX, start.dy, midX, end.dy, end.dx, end.dy);

        canvas.drawPath(path, snakePaint);
      }
    }
  }

  Offset getCellCenter(int cell, double cellSize) {
    int index = cell - 1;
    int row = index ~/ 10;
    int col = index % 10;

    if (row.isOdd) {
      col = 9 - col;
    }

    double x = col * cellSize + cellSize / 2;
    double y = (9 - row) * cellSize + cellSize / 2;

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
