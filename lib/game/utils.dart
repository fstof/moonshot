import 'dart:math';

final rnd = Random();

class CollisionBox {
  final double x;
  final double y;
  final double width;
  final double height;
  const CollisionBox({
    this.x,
    this.y,
    this.width,
    this.height,
  });
}

const DEBUG_COLLISION = false;

bool checkForCollision(CollisionBox flappyBox, CollisionBox targetBox) {
  if (flappyBox == null || targetBox == null) {
    return false;
  }
  return _boxCompare(flappyBox, targetBox);
}

bool _boxCompare(CollisionBox box1, CollisionBox box2) {
  final double obstacleX = box2.x;
  final double obstacleY = box2.y;

  return box1.x < obstacleX + box2.width &&
      box1.x + box1.width > obstacleX &&
      box1.y < box2.y + box2.height &&
      box1.height + box1.y > obstacleY;
}
