import 'package:ads/ads.dart';
import 'package:flame/flame.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/widgets/sprite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';
import '../services/flavor_config.dart';

class HomeScreen extends StatelessWidget {
  final _playSprite = SpriteSheet(
    imageName: 'play.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 2,
    rows: 1,
  );
  final _buttonSprites = SpriteSheet(
    imageName: 'buttons.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 2,
    rows: 4,
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
                SizedBox(height: FlavorConfig.instance.values.showAds ? AdSize.banner.height.toDouble() : 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLeaderboardButton(BlocProvider.of(context)),
                    SizedBox(width: 32),
                    _buildAchievementsButton(BlocProvider.of(context)),
                    SizedBox(width: 32),
                    _buildMusicButton(BlocProvider.of(context)),
                    SizedBox(width: 32),
                  ],
                ),
                Expanded(child: const Offstage()),
                FittedBox(
                  child: 'MOONSHOT'.text.yellow500.xl6.make().pSymmetric(h: 16),
                ),
                Expanded(child: const Offstage()),
                _buildStartButton(BlocProvider.of(context)),
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

  Widget _buildSoundsButton(GameCubit gameBloc) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: _buttonSprites.getSprite(1, (gameBloc.state as GameLoaded).sounds ? 0 : 1),
      pressedSprite: _buttonSprites.getSprite(1, (gameBloc.state as GameLoaded).sounds ? 1 : 0),
      label: null,
      onPressed: () {
        Flame.audio.play('menu_tap.wav');
        gameBloc.toggleSounds();
      },
    );
  }

  Widget _buildAchievementsButton(GameCubit gameBloc) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: _buttonSprites.getSprite(2, 0),
      pressedSprite: _buttonSprites.getSprite(2, 0),
      label: null,
      onPressed: () async {
        Flame.audio.play('menu_tap.wav');
        GamesServices.showAchievements();
      },
    );
  }

  Widget _buildLeaderboardButton(GameCubit gameBloc) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: _buttonSprites.getSprite(3, 0),
      pressedSprite: _buttonSprites.getSprite(3, 0),
      label: null,
      onPressed: () async {
        Flame.audio.play('menu_tap.wav');
        GamesServices.showLeaderboards();
      },
    );
  }

  Widget _buildMusicButton(GameCubit gameBloc) {
    return SpriteButton(
      width: 32,
      height: 32,
      sprite: _buttonSprites.getSprite(0, (gameBloc.state as GameLoaded).music ? 0 : 1),
      pressedSprite: _buttonSprites.getSprite(0, (gameBloc.state as GameLoaded).music ? 1 : 0),
      label: null,
      onPressed: () {
        Flame.audio.play('menu_tap.wav');
        gameBloc.toggleMusic();
      },
    );
  }
}
