import 'package:ads/ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_store/json_store.dart';

import 'main_nonprod.dart';
import 'src/cubit/game_cubit.dart';
import 'src/dao/game_dao.dart';
import 'src/game/moonshot_game.dart';
import 'src/services/flavor_config.dart';
import 'src/ui/game_ui.dart';

void main() async {
  setupNonprodFlavor();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.setOrientation(DeviceOrientation.portraitUp);
  await Flame.util.fullScreen();

  await Flame.audio.loadAll([
    'die.wav',
    'hit.wav',
    'menu_tap.wav',
    'shoot.wav',
  ]);

  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return CircularProgressIndicator(
          backgroundColor: Colors.red,
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return GameApp();
      }
      return CircularProgressIndicator();
    },
  ));
}

class GameApp extends StatelessWidget {
  final MoonshotGame game = MoonshotGame(
    GameCubit(GameDao(JsonStore()), FirebaseAnalytics())..initGame(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.stalinistOneTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: BlocProvider.value(
        value: game.gameCubit,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned.fill(child: game.widget),
                    Positioned.fill(child: GameUI()),
                    if (FlavorConfig.instance.values.showAds)
                      Positioned(
                        child: Container(
                          height: AdSize.banner.height.toDouble(),
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlameGame extends StatelessWidget {
  const FlameGame({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoonshotGame(BlocProvider.of(context)).widget;
  }
}
