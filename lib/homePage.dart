import 'dart:async';
import 'dart:math';
import 'package:bubble_trouble/ball.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'button.dart';
import 'missile.dart';
import 'player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double playerX = 0;

  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = "LEFT";

  void moveLeft() {
    playerX - 0.1 > -1
        ? setState(() => playerX -= 0.1)
        : setState(() => playerX = playerX);

    if (!midShot) {
      missileX = playerX;
    }
  }

  void moveRight() {
    playerX + 0.1 < 1
        ? setState(() => playerX += 0.1)
        : setState(() => playerX = playerX);

    if (!midShot) {
      missileX = playerX;
    }
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(
        Duration(milliseconds: 20),
        (timer) {
          midShot = true;

          setState(() => missileHeight += 10);

          missileHeight > MediaQuery.of(context).size.height * 3 / 4
              ? {
                  resetMissile(),
                  timer.cancel(),
                }
              : {};
          if (ballY > heightToPosition(missileHeight) &&
              (ballX - missileX).abs() < 0.03) {
            resetMissile();
            var flag = Random().nextBool();
            if (flag) {
              ballX = 1;
            } else {
              ballX = -1;
            }
            timer.cancel();
          }
        },
      );
    }
  }

  bool playerDies() {
    if ((ballX - playerX).abs() < 0.05  && ballY > 0.95) {
      return true;
    }
    return false;
  }

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 80;

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(
        () {
          ballY = heightToPosition(height);
        },
      );

      if (ballX - 0.02 < -1) {
        ballDirection = "RIGHT";
      } else if (ballX + 0.02 > 1) {
        ballDirection = "LEFT";
      }
      if (ballDirection == "LEFT") {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == "RIGHT") {
        setState(() {
          ballX += 0.005;
        });
      }

      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Center(
              child: Text("You Lose", style:  TextStyle(color: Colors.white),)),
          );
        });
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed((LogicalKeyboardKey.arrowLeft))) {
          moveLeft();
        } else if (event.isKeyPressed((LogicalKeyboardKey.arrowRight))) {
          moveRight();
        }
        if (event.isKeyPressed((LogicalKeyboardKey.space))) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                color: Colors.pink[100],
                child: Stack(
                  children: [
                    Ball(ballX: ballX, ballY: ballY),
                    Missile(
                      missileX: missileX,
                      missileHeight: missileHeight,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    icons: Icons.play_arrow,
                    function: startGame,
                  ),
                  Button(
                    icons: Icons.arrow_left,
                    function: moveLeft,
                  ),
                  Button(
                    icons: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  Button(
                    icons: Icons.arrow_right,
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
