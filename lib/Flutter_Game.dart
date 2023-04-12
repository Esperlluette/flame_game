import 'dart:async';

import  'package:flame/game.dart';
import 'package:flame_game/actors/GamePlayer.dart';


class Flame_Game extends FlameGame{
  Flame_Game();
  late GamePlayer _duck;

  @override
  Future<void> onLoad()  async{
    await images.loadAll([
      'Sky.png',
      'Duck.png',
      'Tiles.png',
      'Heart.png',
      'Spikes.png',
      'Door.png'
    ]);
    _duck = GamePlayer(position: Vector2(128, -70),);
    add(_duck);
  }
}