import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';

import 'utils.dart';

class Earth extends PositionComponent with Resizable {
  Earth() : super() {
    anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = (size.width) / 2;
    y = (size.height);
    width = size.width;
    height = 100;
  }

  @override
  void render(Canvas c) {
    Paint blue = Paint()..color = Color(0xff0000ff);
    Paint green = Paint()..color = Color(0xff00ff00);
    c.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: width,
          height: height,
        ),
        blue);
    c.drawCircle(Offset(x * 0.1, y + 25), 50, green);
    c.drawCircle(Offset(x * 1.5, y + 60), 100, green);
    c.drawCircle(Offset(x, y + 160), 200, green);
  }

  CollisionBox get collisionBox => CollisionBox(
        x: x - (width / 2),
        y: y - (height / 2),
        width: width,
        height: height,
      );
}
