import 'package:Moonshot/src/utils/game_ids.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';

class HomeScreen extends StatelessWidget {
  final buttonSprites;

  const HomeScreen({Key? key, required this.buttonSprites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLeaderboardButton(context.read()),
                    SizedBox(width: 32),
                    _buildAchievementsButton(context.read()),
                    SizedBox(width: 32),
                    _buildMusicButton(context.read(), state),
                    SizedBox(width: 32),
                  ],
                ),
                Expanded(child: const Offstage()),
                FittedBox(
                  child: 'MOONSHOT'.text.yellow500.xl6.make().pSymmetric(h: 16),
                ),
                Expanded(child: const Offstage()),
                _buildStartButton(context.read()),
                Expanded(child: const Offstage()),
                'High Score: ${state.highScore}'.text.xl.orange100.make().p16(),
              ],
            ),
          );
        } else {
          return const Offstage();
        }
      },
    );
  }

  Widget _buildStartButton(GameCubit cubit) {
    return SpriteButton(
      width: 128,
      height: 128,
      sprite: buttonSprites.getSprite(4, 0),
      pressedSprite: buttonSprites.getSprite(4, 1),
      label: Offstage(),
      onPressed: () {
        FlameAudio.play('menu_tap.wav');
        cubit.startGame();
      },
    );
  }

  Widget _buildAchievementsButton(GameCubit cubit) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: buttonSprites.getSprite(2, 0),
      pressedSprite: buttonSprites.getSprite(2, 0),
      label: Offstage(),
      onPressed: () async {
        FlameAudio.play('menu_tap.wav');
        GamesServices.showAchievements();
      },
    );
  }

  Widget _buildLeaderboardButton(GameCubit cubit) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: buttonSprites.getSprite(3, 0),
      pressedSprite: buttonSprites.getSprite(3, 0),
      label: Offstage(),
      onPressed: () async {
        FlameAudio.play('menu_tap.wav');
        GamesServices.showLeaderboards(
          androidLeaderboardID: leaderboard_high_score,
        );
      },
    );
  }

  Widget _buildSoundsButton(GameCubit cubit, GameLoaded state) {
    print('sound is ${(cubit.state as GameLoaded).sounds}');
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: buttonSprites.getSprite(0, state.sounds ? 0 : 1),
      pressedSprite: buttonSprites.getSprite(0, state.sounds ? 1 : 0),
      label: '${state.sounds ? 'On' : 'Off'}'.text.white.make(),
      onPressed: () {
        FlameAudio.play('menu_tap.wav');
        cubit.toggleSounds();
      },
    );
  }

  Widget _buildMusicButton(GameCubit cubit, GameLoaded state) {
    print('music is ${(cubit.state as GameLoaded).music}');
    return Column(
      children: [
        SpriteButton(
          width: 32,
          height: 32,
          sprite: buttonSprites.getSprite(1, state.music ? 0 : 1),
          pressedSprite: buttonSprites.getSprite(1, state.music ? 0 : 1),
          label: Offstage(),
          onPressed: () {
            FlameAudio.play('menu_tap.wav');
            cubit.toggleMusic();
          },
        ),
        '${state.music ? 'On' : 'Off'}'.text.white.make()
      ],
    );
  }
}
