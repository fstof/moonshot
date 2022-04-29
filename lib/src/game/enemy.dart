import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'moonshot_game.dart';
import 'utils.dart';

class Enemy extends SpriteComponent with HasGameRef<MoonshotGame> {
  static const speed = 300;

  late double targetX;
  double? targetAngle;
  late bool direction;
  late int rotationSpeed;
  late int movementSpeed;
  final bool isChild;
  final bool canHaveChildren;

  Enemy({
    this.canHaveChildren = true,
    double sizex = 64,
    double? speed,
    this.isChild = false,
  }) {
    anchor = Anchor.center;
    direction = rnd.nextBool();
    rotationSpeed = rnd.nextInt(10);
    movementSpeed = speed?.floor() ?? rnd.nextInt(100) + 100;
    size = Vector2.all(sizex);
  }
  @override
  Future<void>? onLoad() async {
    final sheet = SpriteSheet(
      image: await Flame.images.load('astroids.png'),
      srcSize: Vector2.all(32),
    );
    sprite = sheet.getSprite(0, rnd.nextInt(3));

    if (!isChild) {
      y = 0;
      x = rnd.nextInt(gameRef.size.x.floor()).toDouble();
    }
    targetX = rnd.nextInt(gameRef.size.x.floor()).toDouble();
    final netX = (x - targetX);
    final netY = gameRef.size.y;
    targetAngle = atan(netX / netY);

    return super.onLoad();
  }

  void shot() {
    if (canHaveChildren && rnd.nextBool() && y < gameRef.size.y / 2) {
      gameRef.add(
        Enemy(
          canHaveChildren: false,
          sizex: width / 2,
          speed: movementSpeed * 0.5,
          isChild: true,
        )
          ..x = x + 10
          ..y = y,
      );
      gameRef.add(
        Enemy(
          canHaveChildren: false,
          sizex: width / 2,
          speed: movementSpeed * 0.5,
          isChild: true,
        )
          ..x = x - 10
          ..y = y,
      );
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (targetAngle == null) return;
    x += sin(targetAngle!) * movementSpeed * dt;
    y += cos(targetAngle!) * movementSpeed * dt;
    angle = angle + (direction ? rotationSpeed : -rotationSpeed) * dt;

    if (x > gameRef.size.x) {
      x = 0;
    }
    if (x < 0) {
      x = gameRef.size.x;
    }
    if (y > gameRef.size.y || y < 0) {
      gameRef.remove(this);
    }

    if (checkForCollision(collisionBox, gameRef.moon.collisionBox) || checkForCollision(collisionBox, gameRef.earth.collisionBox)) {
      gameRef.remove(this);
      gameRef.crash();
    }
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
        x: x - (width / 2) + 5,
        y: y - (height / 2) + 5,
        width: width - 10,
        height: height - 10,
      );
}
