import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_game/objects/GroundBlock.dart';
import 'package:flame_game/objects/Kiwi.dart';
import 'package:flame_game/objects/hazard/Spike.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:flutter/services.dart';

import '../Flutter_Game.dart';
import '../objects/PlatformBlock.dart';

class GamePlayer extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<Flame_Game>, CollisionCallbacks {
  final double gravity = 10;
  final double jumpSpeed = 600;
  final double terminalvelocity = 150;

  bool hitByEnemy = false;

  bool hasJumped = false;

  bool debug = false;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  int horizontalDirection = 0;
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
    if (other is Kiwi) {
      other.removeFromParent();
      game.KiwisCollected++;
    }
    if (other is Spike) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;

    horizontalDirection -= (keysPressed.contains(LogicalKeyboardKey.keyQ) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? 1
        : 0;

    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    debug = (keysPressed.contains(LogicalKeyboardKey.keyP)) ? true : false;

    hasJumped = (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp));
    return true;
  }

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('duck.png'),
        SpriteAnimationData.sequenced(
            amount: 2, stepTime: 0.12, textureSize: Vector2.all(16)));
    add(
      CircleHitbox()..collisionType = CollisionType.active,
    );
  }

  @override
  void update(double dt) {
    cannotGoLeft();
    cannotGoRight();

    move(dt);
    // if (position.x - 36 <= 0 && horizontalDirection < 0) {
    //   velocity.x = 0;
    // }

    // If duck fell in pit, then game over.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    printPose();
    gameOver();
    flipSprite();
    jump();

    super.update(dt);
  }

  void folow() {
    print(
        "Tracktrace of duck  \n X value : ${this.position.x} \n Y value: ${this.position.y}");
  }

  void flipSprite() {
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
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

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
      game.health--;

      var hud = game.children.last;
      hud.remove(hud.children.last);
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }

  void printPose() {
    if (position.x + 64 >= game.size.x / 3 && horizontalDirection > 0) {
      print(
          "pos X :${position.x + 64} game size X :${game.size.x / 2} Horizontal direction : $horizontalDirection");
      velocity.x = -1;
      game.objectSpeed = -moveSpeed;
    }
  }

  void gameOver() {
    if (game.health <= 0) {
      game.calculateScore();
      removeFromParent();
    }
  }

  void cannotGoLeft() {
    if (position.x <= 20 && horizontalDirection == -1) {
      horizontalDirection = 0;
    }
  }

  void move(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;
  }

  void cannotGoRight() {
    if (position.x >= 1200 && horizontalDirection == 1) {
      horizontalDirection = 0;
    }
  }
}
