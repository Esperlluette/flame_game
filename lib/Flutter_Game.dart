import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_game/actors/GamePlayer.dart';
import 'package:flame_game/overlays/hud.dart';

import 'managers/segment_manager.dart';
import 'objects/GroundBlock.dart';
import 'objects/Star.dart';
import 'objects/PlatformBlock.dart';
import 'package:flutter/material.dart';

import 'objects/hazard/Spike.dart';

class Flame_Game extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  Flame_Game();
  late GamePlayer _duck;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  bool scroll = false;
  int starsCollected = 0;
  int health = 3;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'sky.png',
      'duck.png',
      'platform.png',
      'ground.png',
      'heart.png',
      'spike.png',
      'door.png',
      'terrain.png',
    ]);
    initializeGame(true);
  }

  void initializeGame(bool loadHud) {
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
    add(Hud());
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void loadGameSegments(int segmentsIndex, double xPositionOffset) {
    for (final block in segments[segmentsIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(GroundBlock(
              gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Spike:
          add(Spike(
              gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case PlatformBlock:
          add(PlatformBlock(
              gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Star:
          add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      scroll = false;
      overlays.add('GameOver');
    }
    super.update(dt);
  }
}
