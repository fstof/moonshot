import 'package:flame/components.dart';

import 'utils.dart';

class Star extends SpriteComponent with HasGameRef {
  late int speed;

  Star() {
    anchor = Anchor.center;
    speed = rnd.nextInt(100) + 50;
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('star.png');
    size = Vector2.all(32);
    return super.onLoad();
  }

  void reset() {
    x = rnd.nextInt(gameRef.size.x.floor()).toDouble();
    y = 0;

    speed = rnd.nextInt(100) + 50;
    width = height = speed * 0.5;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = rnd.nextInt(size.x.floor()).toDouble();
    y = rnd.nextInt(size.y.floor()).toDouble();
  }

  @override
  void update(double dt) {
    super.update(dt);

    y += speed * dt;

    if (size != null) {
      if (x > gameRef.size.x || x < 0) {
        reset();
      }
      if (y > gameRef.size.y || y < 0) {
        reset();
      }
    }
  }
}
