import 'dart:ui';

import 'package:flame/components.dart';

import 'utils.dart';

class Earth extends SpriteComponent with HasGameRef {
  Earth() {
    anchor = Anchor.center;
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('earth.png');
    size = Vector2(gameRef.size.x, 100);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - height / 2);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
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
        x: x - (width / 2),
        y: y - (height / 2),
        width: width,
        height: height,
      );
}
