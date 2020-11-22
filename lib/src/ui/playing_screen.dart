import 'package:Moonshot/src/services/flavor_config.dart';
import 'package:ads/ads.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cubit/game_cubit.dart';

class PlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      cubit: BlocProvider.of(context),
      builder: (context, state) {
        if (state is GameLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (FlavorConfig.instance.values.showAds)
                Positioned(
                  child: Container(
                    height: AdSize.banner.height.toDouble(),
                    color: Color(0xff000000),
                  ),
                ),
              'Score: ${state.score}'.text.xl.orange100.make(),
            ],
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}
