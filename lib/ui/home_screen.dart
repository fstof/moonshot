import 'package:flame/flame.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/widgets/sprite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';

class HomeScreen extends StatelessWidget {
  final _playSprite = SpriteSheet(
    imageName: 'play.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 2,
    rows: 1,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      cubit: BlocProvider.of(context),
      builder: (context, state) {
        if (state is GameLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                'High Score: ${state.highScore}'.text.orange100.make(),
                Expanded(child: const Offstage()),
                FittedBox(child: 'MOONSHOT'.text.yellow500.xl6.make()),
                Expanded(child: const Offstage()),
                _buildStartButton(BlocProvider.of(context)),
                Expanded(child: const Offstage()),
              ],
            ),
          );
        } else {
          return const Offstage();
        }
      },
    );
  }

  Widget _buildStartButton(GameCubit gameBloc) {
    return SpriteButton(
      width: 128,
      height: 128,
      sprite: _playSprite.getSprite(0, 0),
      pressedSprite: _playSprite.getSprite(0, 1),
      label: null,
      onPressed: () {
        Flame.audio.play('menu_tap.wav');
        gameBloc.startGame();
      },
    );
  }
}
