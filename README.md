# Snake and Ladder Game (Flutter)

A simple Snake and LAdder Game built using **Flutter**.
This project demonstrates grid based UI, turn based logic, dice animation and game rules implementation.

---

## Features Implemented

### Game Board

- 10x10 grid
- Each cell displays it's number
- Visual markers for player positions

### Two Player Support

- Player 1 (Red)
- Player 2 (Blue)
- Turn-based gameplay
- Current player's turn displayed

### Dice System

- Random dice generation (1-6) using dart:math
- Dice roll animation
- Dice button disabled while rolling

### Snakes and Ladders

- Predefined snakes and ladders using `Map<int, int>`
- Automatic jump when landing on snake or ladder

### Win Condition

- Player wins when reaching cell 100
- Popup dialog shown on win
- Option to restart the game

---

## How to Play

1. Press **Roll Dice**
2. Player moves based on dice number
3. If player lands on:

- ladder -> moves up
- snake -> moves down

4. Turns alternate between Player 1 and Player 2
5. First player to reach **100** wins

---

## Tech Stack

- Flutter
- Dart

---

### Prerequisites

- Flutter SDK installed
- Android Studio/ VS Code
- Emulator or physical device

### Run the game

```bash
flutter pub get
flutter run
```
