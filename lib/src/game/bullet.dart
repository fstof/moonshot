import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import 'enemy.dart';
import 'moonshot_game.dart';
import 'utils.dart';

class Bullet extends SpriteComponent with HasGameRef<MoonshotGame> {
  final double targetAngle;
  bool used = false;

  Bullet(this.targetAngle, double initialX, double initialY) {
    anchor = Anchor.center;
    x = initialX;
    y = initialY;
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('bullet.png');
    size = Vector2(6, 12);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += 10 * dt;
    x += 5 * cos(targetAngle - 0);
    y += 5 * sin(targetAngle - 0);
    if (size != null) {
      if (y > gameRef.size.y || y < 0 || x > gameRef.size.x || x < 0) {
        gameRef.remove(this);
      }
    }

    if (checkForCollision(collisionBox, gameRef.earth.collisionBox)) {
      gameRef.remove(this);
    }
    gameRef.children.forEach((component) {
      if (component is Enemy) {
        if (checkForCollision(collisionBox, component.collisionBox)) {
          if (!used) {
            used = true;
            component.shot();
            gameRef.score();
            gameRef.remove(component);
            gameRef.remove(this);
          }
        }
      }
    });
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
