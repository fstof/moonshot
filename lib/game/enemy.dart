import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/spritesheet.dart';

import 'moonshot_game.dart';
import 'utils.dart';

class Enemy extends SpriteComponent with Resizable {
  static const speed = 300;
  static final sheet = SpriteSheet(
    imageName: 'astroids.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 3,
    rows: 1,
  );
  final MoonshotGame _game;

  double targetX;
  double targetAngle;
  bool direction;
  int rotationSpeed;
  int movementSpeed;
  final List<Enemy> children = [];
  final bool isChild;
  final bool haveChildren;

  Enemy(
    this._game, {
    this.haveChildren = true,
    double size = 64,
    double speed,
    this.isChild = false,
  }) : super.fromSprite(size, size, sheet.getSprite(0, rnd.nextInt(3))) {
    anchor = Anchor.center;
    direction = rnd.nextBool();
    rotationSpeed = rnd.nextInt(10);
    movementSpeed = speed?.floor() ?? rnd.nextInt(100) + 100;
  }

  void shot() {
    if (haveChildren && rnd.nextBool() && y < size.height / 2) {
      _game.add(
        Enemy(
          _game,
          haveChildren: false,
          size: width / 2,
          speed: movementSpeed * 0.5,
          isChild: true,
        )
          ..x = x + 10
          ..y = y,
      );
      _game.add(
        Enemy(
          _game,
          haveChildren: false,
          size: width / 2,
          speed: movementSpeed * 0.5,
          isChild: true,
        )
          ..x = x - 10
          ..y = y,
      );
    }
  }

  @override
  resize(Size size) {
    super.resize(size);
    if (!isChild) {
      y = 0;
      x = rnd.nextInt(size.width.floor()).toDouble();
    }
    targetX = rnd.nextInt(size.width.floor()).toDouble();
    final netX = (x - targetX);
    final netY = size.height;
    targetAngle = atan(netX / netY);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (targetAngle == null) return;
    x += sin(targetAngle) * movementSpeed * dt;
    y += cos(targetAngle) * movementSpeed * dt;
    angle = angle + (direction ? rotationSpeed : -rotationSpeed) * dt;

    if (x > size.width) {
      x = 0;
    }
    if (x < 0) {
      x = size.width;
    }
    if (y > size.height || y < 0) {
      _game.markToRemove(this);
    }

    if (checkForCollision(collisionBox, _game.moon.collisionBox)) {
      _game.markToRemove(this);
      _game.crash();
    }
    if (checkForCollision(collisionBox, _game.earth.collisionBox)) {
      _game.markToRemove(this);
      _game.crash();
    }
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
        x: x - (width / 2) + 5,
        y: y - (height / 2) + 5,
        width: width - 10,
        height: height - 10,
      );
}
