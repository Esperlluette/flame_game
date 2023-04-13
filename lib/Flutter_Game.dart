import 'dart:async';

import  'package:flame/game.dart';
import 'package:flame_game/actors/GamePlayer.dart';

import 'managers/segment_manager.dart';
import 'objects/GroundBlock.dart';
import 'objects/PlatformBlock.dart';


class Flame_Game extends FlameGame{
  Flame_Game();
  late GamePlayer _duck;
  double objectSpeed = 0.0;

  @override
  Future<void> onLoad()  async{
    await images.loadAll([
      'sky.png',
      'duck.png',
      'tile.png',
      'heart.png',
      'spikes.png',
      'door.png'
    ]);
    initializeGame();
  }


  void initializeGame(){
    print("---Initializing Game.");

    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i < segmentsToLoad; i++) {
      loadGameSegments(i, (640*i).toDouble());
    }

    _duck = GamePlayer(position: Vector2(128, size.y - 70),);
    add(_duck);
    print("Duck X ${_duck.x},Duck Y : ${_duck.y}");
  }

  void loadGameSegments(int segmentsIndex, double xPositionOffset) {
  for (final block in segments[segmentsIndex]) {
    switch (block.blockType) {
      case GroundBlock:
        break;
      case PlatformBlock:
        add(PlatformBlock(
            gridPosition: block.gridPosition, xOffset: xPositionOffset));
        break;
    }
  }
}
}