import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';
import 'enums.dart';
import 'game_button.dart';

class CrashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                'Score: ${state.score}'.text.xl.orange100.make(),
                'High Score: ${state.highScore}'.text.xl.orange100.make(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameButton(
                      text: 'HOME',
                      onPressed: () {
                        FlameAudio.play('menu_tap.wav');
                        BlocProvider.of<GameCubit>(context).changeScreen(Screen.Home);
                      },
                    ),
                    GameButton(
                      text: 'RETRY',
                      onPressed: () {
                        FlameAudio.play('menu_tap.wav');
                        BlocProvider.of<GameCubit>(context).retryGame();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}
