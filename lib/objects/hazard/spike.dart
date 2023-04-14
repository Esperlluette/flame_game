import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../Flutter_Game.dart';

class Spike extends SpriteComponent
    with HasGameRef<Flame_Game> {
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();

  Spike({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final spriteImage = game.images.fromCache('spike.png');
    sprite = Sprite(spriteImage);
    position = Vector2((gridPosition.x * size.x) + xOffset,
        game.size.y - (gridPosition.y * size.y));
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();
    super.update(dt);
  }
}