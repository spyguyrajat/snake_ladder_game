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

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snake and Ladder")),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 100,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
        ),
        itemBuilder: (context, index) {
          int cellNumber = 100 - index;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: index % 2 == 0 ? Colors.green[100] : Colors.green[200],
            ),
            child: Center(child: Text(cellNumber.toString())),
          );
        },
      ),
    );
  }
}
