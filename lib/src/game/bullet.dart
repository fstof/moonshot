import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';

import 'enemy.dart';
import 'moonshot_game.dart';
import 'utils.dart';

class Bullet extends SpriteComponent with Resizable {
  final MoonshotGame _game;
  final double targetAngle;
  bool used = false;

  Bullet(this._game, this.targetAngle, double initialX, double initialY)
      : super.fromSprite(6, 12, Sprite('bullet.png')) {
    anchor = Anchor.center;
    // angle = targetAngle;
    x = initialX;
    y = initialY;
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += 10 * dt;
    x += 5 * cos(targetAngle - 0);
    y += 5 * sin(targetAngle - 0);
    if (size != null) {
      if (y > size.height || y < 0 || x > size.width || x < 0) {
        _game.markToRemove(this);
      }
    }

    if (checkForCollision(collisionBox, _game.earth.collisionBox)) {
      _game.markToRemove(this);
    }
    _game.components.forEach((component) {
      if (component is Enemy) {
        if (checkForCollision(collisionBox, component.collisionBox)) {
          if (!used) {
            used = true;
            component.shot();
            _game.score();
            _game.markToRemove(component);
            _game.markToRemove(this);
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
      canvas.drawRect(
          Rect.fromLTWH(box.x, box.y, box.width, box.height), paint);
    }
  }

  CollisionBox get collisionBox => CollisionBox(
        x: x - (width / 2),
        y: y - (height / 2),
        width: width,
        height: height,
      );
}
