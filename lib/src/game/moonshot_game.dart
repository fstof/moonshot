import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../cubit/game_cubit.dart';
import '../ui/enums.dart';
import 'background.dart';
import 'earth.dart';
import 'enemy.dart';
import 'gun.dart';
import 'moon.dart';

class MoonshotGame extends FlameGame with HasDraggables, HasTappables {
  late Gun gun;
  Background? background;
  late Moon moon;
  late Earth earth;
  JoystickComponent? joystick;
  late HudButtonComponent actionButton;
  TimerComponent? timer;
  final GameCubit gameCubit;
  GameLoaded? currentState;

  MoonshotGame(this.gameCubit) : super() {
    _initGame();
  }

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

  void _initGame() {
    gameCubit.stream.listen((state) {
      print('state newScreen: ${(state as GameLoaded).screen}');

      if (currentState == null) {
        currentState = state;
      }
      if (currentState!.paused && !state.paused) {
        resumeEngine();
      } else if (!currentState!.paused && state.paused) {
        pauseEngine();
      }
      if (currentState!.screen != state.screen && state.screen == Screen.Playing) {
        currentState = state;
        start();
      }
      currentState = state;
      if (currentState!.addEnemy == true) {
        add(Enemy());
      }
    });
  }

  void start() {
    print('starting game by adding the components');
    add(background = Background());
    add(moon = Moon());
    add(earth = Earth());
    add(joystick = _createJoystick());
    add(actionButton = _createActionButton());
    add(gun = Gun(joystick));

    actionButton.onPressed = () {
      gun.shoot();
    };
  }

  void crash() {
    children.forEach(remove);
    gameCubit.crash();
  }

  void score() {
    gameCubit.addScore();
  }

  JoystickComponent _createJoystick() {
    final knobPaint = BasicPalette.white.withAlpha(100).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    return JoystickComponent(
      priority: 0,
      size: 50,
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
  }

  HudButtonComponent _createActionButton() {
    final buttonPaint = BasicPalette.white.withAlpha(100).paint();
    return HudButtonComponent(
      priority: 1,
      size: Vector2.all(100),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      button: CircleComponent(radius: 50, paint: buttonPaint),
    );
  }
}
