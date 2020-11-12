import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

import 'utils.dart';

class Moon extends SpriteComponent {
  Moon() : super.fromSprite(64.0, 64.0, Sprite('moon.png')) {
    anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    x = (size.width) / 2;
    y = (size.height) / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (DEBUG_COLLISION) {
      final box = collisionBox;
      final paint = Paint()..color = Color(0xffffff00);
      canvas.restore();
      canvas.drawRect(
          Rect.fromLTWH(box.x, box.y, box.width, box.height), paint);
    }
  }

  CollisionBox get collisionBox => CollisionBox(
        x: x - (width / 2) + 10,
        y: y - (height / 2) + 10,
        width: width - 20,
        height: height - 20,
      );
}
