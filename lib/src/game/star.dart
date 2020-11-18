import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';

import 'utils.dart';

class Star extends SpriteComponent with Resizable {
  int speed;

  Star() : super.fromSprite(32, 32, Sprite('star.png')) {
    anchor = Anchor.center;
    speed = rnd.nextInt(100) + 50;
  }

  void reset() {
    x = rnd.nextInt(size.width.floor()).toDouble();
    y = 0;

    speed = rnd.nextInt(100) + 50;
    width = height = speed * 0.5;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    x = rnd.nextInt(size.width.floor()).toDouble();
    y = rnd.nextInt(size.height.floor()).toDouble();
  }

  @override
  void update(double dt) {
    super.update(dt);

    y += speed * dt;

    if (size != null) {
      if (x > size.width || x < 0) {
        reset();
      }
      if (y > size.height || y < 0) {
        reset();
      }
    }
  }
}
