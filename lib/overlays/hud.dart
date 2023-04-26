import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../Flutter_Game.dart';
import 'heart.dart';

class Hud extends PositionComponent with HasGameRef<Flame_Game> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;

  @override
  Future<void>? onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.KiwisCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_scoreTextComponent);

    final spriteSheet = SpriteSheet(
        image: game.images.fromCache('kiwi.png'), srcSize: Vector2.all(32));

    add(
      SpriteComponent(
        sprite: spriteSheet.getSprite(0, 0),
        position: Vector2(game.size.x - 100, 20),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.KiwisCollected}';

    super.update(dt);
  }
}

// void updateHealthDisplay(Flame_Game game) async {
//   // Supprimer les composants HeartHealthComponent existants
//   final hearts = game.components.whereType<HeartHealthComponent>().toList();
//   for (final heart in hearts) {
//     await heart.removeFromParent();
//   }

//   // Ajouter de nouveaux composants HeartHealthComponent en fonction de la valeur actuelle de game.health
//   for (var i = 1; i <= game.health; i++) {
//     final positionX = 40 * i;
//     await game.add(
//       HeartHealthComponent(
//         heartNumber: i,
//         position: Vector2(positionX.toDouble(), 20),
//         size: Vector2.all(32),
//       ),
//     );
//   }
// }
