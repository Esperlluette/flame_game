import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_game/actors/GamePlayer.dart';

import 'managers/segment_manager.dart';
import 'objects/GroundBlock.dart';
import 'objects/Heart.dart';
import 'objects/PlatformBlock.dart';
import 'package:flutter/material.dart';

import 'objects/hazard/spike.dart';

class Flame_Game extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  Flame_Game();
  late GamePlayer _duck;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'sky.png',
      'duck.png',
      'platform.png',
      'ground.png',
      'heart.png',
      'spike.png',
      'door.png'
    ]);
    initializeGame();
  }

  void initializeGame() {
    print("---Initializing Game.");

    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i < segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _duck = GamePlayer(
      position: Vector2(128, size.y - 128),
    );
    add(_duck);
    print("Duck X ${_duck.x},Duck Y : ${_duck.y}");
  }

  

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }


  void loadGameSegments(int segmentsIndex, double xPositionOffset) {
    for (final block in segments[segmentsIndex]) {
      switch (block.blockType) {
        case GroundBlock:
        add(GroundBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
          case Spike: 
          add(Spike(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case PlatformBlock:
          add(PlatformBlock(
              gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Heart:
          add(Heart(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }
}
