import 'package:flutter/material.dart';

import '../Flutter_Game.dart';

class GameOver extends StatelessWidget {
  // Reference to parent game.
  final Flame_Game game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 230,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Score : ',
                    style: TextStyle(color: whiteTextColor, fontSize: 20),
                  ),
                  Text("${game.score}",
                      style: TextStyle(color: whiteTextColor, fontSize: 20))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'High Score : ',
                    style: TextStyle(color: whiteTextColor, fontSize: 20),
                  ),
                  Text("${game.score}",
                      style: TextStyle(color: whiteTextColor, fontSize: 20))
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                    game.overlays.remove('GameOver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
