import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/objects/GroundBlock.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:flutter/services.dart';

import '../Flutter_Game.dart';
import '../objects/PlatformBlock.dart';

class GamePlayer extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<Flame_Game>, CollisionCallbacks {
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double terminalvelocity = 150;

  bool hasJumped = false;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  int horizontalDirction = 0;
  GamePlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirction = 0;

    horizontalDirction -= (keysPressed.contains(LogicalKeyboardKey.keyQ) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? 1
        : 0;

    horizontalDirction += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = (keysPressed.contains(LogicalKeyboardKey.space)||keysPressed.contains(LogicalKeyboardKey.arrowUp));
    return true;
  }

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('duck.png'),
        SpriteAnimationData.sequenced(
            amount: 2, stepTime: 0.12, textureSize: Vector2.all(16)));
    add(
      RectangleHitbox()..collisionType = CollisionType.active,
    );
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirction * moveSpeed;
    position += velocity * dt;

    flipSprite();
    jump();

    super.update(dt);
  }

  void folow() {
    print(
        "Tracktrace of duck  \n X value : ${this.position.x} \n Y value: ${this.position.y}");
  }

  void flipSprite() {
    if (horizontalDirction < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirction > 0 && scale.x < 0) {
      flipHorizontally();
    }
  }

  void jump() {
    velocity.y += gravity;
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = true;
    }
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalvelocity);
  }
}
