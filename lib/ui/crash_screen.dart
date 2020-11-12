import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';
import 'enums.dart';

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
                TextButton(
                  child: FittedBox(
                    child: 'Home'.text.blue200.xl6.make(),
                  ),
                  onPressed: () {
                    Flame.audio.play('menu_tap.wav');
                    BlocProvider.of<GameCubit>(context)
                        .changeScreen(Screen.Home);
                  },
                ),
                'Score: ${state.score}'.text.orange100.make(),
                'High Score: ${state.highScore}'.text.orange100.make(),
                TextButton(
                  child: FittedBox(
                    child: 'Retry'.text.blue200.xl6.make(),
                  ),
                  onPressed: () {
                    Flame.audio.play('menu_tap.wav');
                    BlocProvider.of<GameCubit>(context).retryGame();
                  },
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
