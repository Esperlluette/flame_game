import 'package:flame_game/Flutter_Game.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/game.dart';

void main() {
  runApp(const GameWidget<Flame_Game>.controlled(gameFactory: Flame_Game.new,));
}