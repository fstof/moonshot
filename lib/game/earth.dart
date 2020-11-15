import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';

import 'utils.dart';

class Earth extends SpriteComponent with Resizable {
  Earth() : super.fromSprite(128.0, 32.0, Sprite('earth.png')) {
    anchor = Anchor.bottomCenter;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = (size.width) / 2;
    y = (size.height);
    width = size.width;
    height = 100;
  }

  CollisionBox get collisionBox => CollisionBox(
        x: x - (width / 2),
        y: y - (height / 2),
        width: width,
        height: height,
      );
}
