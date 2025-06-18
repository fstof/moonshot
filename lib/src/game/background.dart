import 'package:flame/components.dart';

import 'star.dart';

class Background extends PositionComponent with HasGameReference {
  @override
  Future<void>? onLoad() async {
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    game.add(Star());
    return super.onLoad();
  }
}
