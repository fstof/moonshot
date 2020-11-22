import 'package:flame/components/joystick/joystick_action.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';
import 'package:flame/components/timer_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/time.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../cubit/game_cubit.dart';
import '../ui/enums.dart';
import 'background.dart';
import 'earth.dart';
import 'enemy.dart';
import 'gun.dart';
import 'moon.dart';

class MoonshotGame extends BaseGame with MultiTouchDragDetector {
  Gun gun;
  Moon moon;
  Earth earth;
  JoystickComponent joystick;
  TimerComponent timer;
  final GameCubit gameCubit;
  GameLoaded currentState;

  MoonshotGame(this.gameCubit) : super() {
    _initGame();
  }

  void _initGame() {
    gameCubit.listen((state) {
      print('state newScreen: ${(state as GameLoaded)?.screen}');

      if (state is GameLoaded) {
        if (currentState == null) {
          currentState = state;
        }
        if (currentState.paused && !state.paused) {
          resumeEngine();
        } else if (!currentState.paused && state.paused) {
          pauseEngine();
        }
        if (currentState.screen != state.screen && state.screen == Screen.Playing) {
          currentState = state;
          start();
        }
        currentState = state;
        if (currentState.addEnemy) {
          add(Enemy(this));
        }
      } else {
        print('game not ready');
      }
    });
  }

  void start() {
    print('starting game by adding the components');
    add(Background(this));
    add(moon = Moon());
    add(earth = Earth());
    add(gun = Gun(this));
    add(joystick = _createJoystick());
    joystick.addObserver(gun);
  }

  void crash() {
    components.forEach(markToRemove);
    gameCubit.crash();
    Flame.audio.play('die.wav');
  }

  void score() {
    gameCubit.addScore();
    Flame.audio.play('hit.wav');
  }

  @override
  void onReceiveDrag(DragEvent drag) {
    joystick?.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  JoystickComponent _createJoystick() {
    return JoystickComponent(
      componentPriority: 0,
      directional: JoystickDirectional(),
      actions: [
        JoystickAction(
          actionId: 1,
          margin: const EdgeInsets.all(50),
        ),
      ],
    );
  }
}
