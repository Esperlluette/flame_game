import 'dart:async';

import 'package:flame_game/Flutter_Game.dart';
import 'package:flame/components.dart';

enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameRef<Flame_Game> {
  final int heartNumber;
  
  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final availableSprite =
        await game.loadSprite('heart.png', srcSize: Vector2.all(16));

    final unavailableSprite =
        await game.loadSprite('spike.png', srcSize: Vector2.all(16));

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite
    };

    current = HeartState.available;
  }
}
