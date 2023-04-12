import 'package:flame/components.dart';

import '../Flutter_Game.dart';

class GamePlayer extends SpriteAnimationComponent with HasGameRef<Flame_Game> {
  GamePlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Duck.png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.12, textureSize: Vector2.all(16)));
  }
}
