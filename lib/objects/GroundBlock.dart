import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../Flutter_Game.dart';
import '../managers/segment_manager.dart';

class GroundBlock extends SpriteComponent with HasGameRef<Flame_Game> {
  late UniqueKey _blockKey = UniqueKey();
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();

  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {

    final spritesheet = SpriteSheet(image: game.images.fromCache('terrain.png'), srcSize: Vector2.all(32));
    // final groundImage = game.images.fromCache('ground.png');
    sprite = spritesheet.getSprite(0, 3);
    position = Vector2((gridPosition.x * size.x) + xOffset,
        game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition){
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    if (position.x <-size.x){
      removeFromParent();
      if (gridPosition.x == 0){
        game.loadGameSegments(Random().nextInt(segments.length), game.lastBlockXPosition);
      }
    }

    if (gridPosition.x == 9 ){
      if (game.lastBlockKey == _blockKey){
        game.lastBlockXPosition = position.x + size.x -10;
      } 
    }

    if (game.health <= 0) {
    removeFromParent();
}

    super.update(dt);
  }
}