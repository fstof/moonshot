import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'bullet.dart';

class Gun extends PositionComponent with HasGameReference {
  final JoystickComponent? joystick;

  late SpriteAnimation animation;
  late SpriteAnimationTicker ticker;
  bool firing = false;

  Gun(this.joystick) {
    anchor = Anchor.center;
    width = 128;
    height = 128;
  }
  @override
  Future<void>? onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      await Flame.images.load('gun.png'),
      SpriteAnimationData.sequenced(amount: 4, textureSize: Vector2.all(64), stepTime: 0.05, loop: false),
    );
    ticker = animation.createTicker();
    ticker.onComplete = () {
      if (ticker.done()) {
        game.add(
          Bullet(
            angle - 1.5,
            x + 64 * cos(angle - 1.5),
            y + 64 * sin(angle - 1.5),
          ),
        );
      }
    };
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    x = (size.x) / 2;
    y = (size.y) / 2;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick!.direction != JoystickDirection.idle) {
      angle = joystick!.delta.screenAngle();
    }
    if (firing) {
      ticker.update(dt);

      if (ticker.done()) {
        firing = false;
        ticker.reset();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // prepareCanvas(canvas);

    ticker.getSprite().render(
          canvas,
          size: Vector2(width, height),
          // overridePaint: overridePaint,
        );
  }

  void shoot() {
    firing = true;
    FlameAudio.play('shoot.wav');
  }
  // @override
  // void joystickAction(JoystickActionEvent event) {
  //   if (event.event == ActionEvent.DOWN) {
  //     firing = true;
  //     FlameAudio.play('shoot.wav');
  //   }
  // }

  // @override
  // void joystickChangeDirectional(JoystickDirectionalEvent event) {
  //   if (event.directional != JoystickMoveDirectional.IDLE) {
  //     angle = event.radAngle + 1.5;
  //   }
  //   // switch (event.directional) {
  //   //   case JoystickMoveDirectional.MOVE_LEFT:
  //   //   case JoystickMoveDirectional.MOVE_UP_LEFT:
  //   //   case JoystickMoveDirectional.MOVE_DOWN_LEFT:
  //   //     angle -= event.intensity * 0.1;
  //   //     break;
  //   //   case JoystickMoveDirectional.MOVE_RIGHT:
  //   //   case JoystickMoveDirectional.MOVE_UP_RIGHT:
  //   //   case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
  //   //     angle += event.intensity * 0.1;
  //   //     break;
  //   // }
  // }
}
