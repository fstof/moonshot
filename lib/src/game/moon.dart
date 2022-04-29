import 'dart:ui';

import 'package:flame/components.dart';

import 'utils.dart';

class Moon extends SpriteComponent {
  Moon() {
    anchor = Anchor.center;
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('moon.png');
    size = Vector2.all(64);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    x = (size.x) / 2;
    y = (size.y) / 2;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (DEBUG_COLLISION) {
      final box = collisionBox;
      final paint = Paint()..color = Color(0xffffff00);
      canvas.restore();
      canvas.drawRect(Rect.fromLTWH(box.x, box.y, box.width, box.height), paint);
    }
  }

  CollisionBox get collisionBox => CollisionBox(
        x: x - (width / 2) + 10,
        y: y - (height / 2) + 10,
        width: width - 20,
        height: height - 20,
      );
}
