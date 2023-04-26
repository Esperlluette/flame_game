import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../Flutter_Game.dart';

class Kiwi extends SpriteAnimationComponent with HasGameRef<Flame_Game> {
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();

  Kiwi({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {

    animation = SpriteAnimation.fromFrameData(game.images.fromCache('kiwi.png'), SpriteAnimationData.sequenced(amount: 17 , stepTime: 0.5 ,textureSize: Vector2.all(32)));

    // final KiwiImage = game.images.fromCache('heart.png');
    // sprite = Sprite(KiwiImage);
    position = Vector2((gridPosition.x * size.x) + xOffset + (size.x / 2),
        game.size.y - (gridPosition.y * size.y) - (size.y / 2));
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        )));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();
    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
