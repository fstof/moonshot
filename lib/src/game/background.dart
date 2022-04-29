import 'package:flame/components.dart';

import 'star.dart';

class Background extends PositionComponent with HasGameRef {
  @override
  Future<void>? onLoad() {
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    gameRef.add(Star());
    return super.onLoad();
  }
}
