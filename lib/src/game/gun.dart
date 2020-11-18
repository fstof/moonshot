import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/flame.dart';

import 'bullet.dart';
import 'moonshot_game.dart';

class Gun extends PositionComponent with JoystickListener {
  final MoonshotGame _game;

  Animation animation;
  bool firing = false;

  Gun(this._game) {
    anchor = Anchor.center;
    width = 128;
    height = 128;

    animation = Animation.sequenced(
      'gun.png',
      4,
      textureWidth: 64,
      textureHeight: 64,
      loop: false,
      stepTime: 0.05,
    );
    animation.onCompleteAnimation = () {
      if (animation.done()) {
        _game.add(
          Bullet(
            _game,
            angle - 1.5,
            x + 64 * cos(angle - 1.5),
            y + 64 * sin(angle - 1.5),
          ),
        );
      }
    };
  }

  @override
  void resize(Size size) {
    x = (size.width) / 2;
    y = (size.height) / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (firing) {
      animation.update(dt);

      if (animation.done()) {
        firing = false;
        animation.currentIndex = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    prepareCanvas(canvas);
    animation.getSprite().render(
          canvas,
          width: width,
          height: height,
          // overridePaint: overridePaint,
        );
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN) {
      firing = true;
      Flame.audio.play('shoot.wav');
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != JoystickMoveDirectional.IDLE) {
      angle = event.radAngle + 1.5;
    }
    // switch (event.directional) {
    //   case JoystickMoveDirectional.MOVE_LEFT:
    //   case JoystickMoveDirectional.MOVE_UP_LEFT:
    //   case JoystickMoveDirectional.MOVE_DOWN_LEFT:
    //     angle -= event.intensity * 0.1;
    //     break;
    //   case JoystickMoveDirectional.MOVE_RIGHT:
    //   case JoystickMoveDirectional.MOVE_UP_RIGHT:
    //   case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
    //     angle += event.intensity * 0.1;
    //     break;
    // }
  }
}
