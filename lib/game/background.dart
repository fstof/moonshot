import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';

import 'moonshot_game.dart';
import 'star.dart';

class Background extends PositionComponent with Resizable {
  final MoonshotGame _game;

  Background(this._game) {
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
    _game.add(Star());
  }

  @override
  void render(Canvas canvas) {}
}
