import 'package:flame_game/Flutter_Game.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/game.dart';

import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';

void main() {
  runApp(
    GameWidget<Flame_Game>.controlled(
      gameFactory: Flame_Game.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}