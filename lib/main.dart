import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_store/json_store.dart';

import 'main_nonprod.dart';
import 'src/cubit/game_cubit.dart';
import 'src/dao/game_dao.dart';
import 'src/game/moonshot_game.dart';
import 'src/services/app_ads.dart';
import 'src/ui/enums.dart';
import 'src/ui/game_ui.dart';

void main() async {
  setupNonprodFlavor();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  AppAds.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);
  await Flame.device.fullScreen();

  await FlameAudio.audioCache.loadAll([
    'die.wav',
    'crash.wav',
    'hit.wav',
    'menu_tap.wav',
    'shoot.wav',
    'playing.wav',
  ]);

  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return CircularProgressIndicator(backgroundColor: Colors.red);
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
    GameCubit(GameDao(JsonStore()), FirebaseAnalytics.instance)..initGame(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.stalinistOneTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: BlocProvider.value(
        value: game.gameCubit,
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<GameCubit, GameState>(
                builder: (context, state) {
                  if (state is GameLoaded && (state.screen == Screen.Playing || state.screen == Screen.Home)) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: AdWidget(ad: AppAds.myBanner),
                      height: AppAds.myBanner.size.height.toDouble(),
                      margin: EdgeInsets.only(bottom: 8),
                    );
                  } else {
                    return Offstage();
                  }
                },
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned.fill(child: GameWidget(game: game)),
                    Positioned.fill(child: Builder(builder: (context) => GameUI())),
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
  const FlameGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: MoonshotGame(BlocProvider.of(context)));
  }
}
