import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_store/json_store.dart';

import 'src/cubit/game_cubit.dart';
import 'src/dao/game_dao.dart';
import 'src/game/moonshot_game.dart';
import 'src/ui/game_ui.dart';

void main() async {
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
        return GameApp(
          game: MoonshotGame(
            GameCubit(GameDao(JsonStore()), FirebaseAnalytics())..initGame(),
          ),
        );
      }
      return CircularProgressIndicator();
    },
  ));
}

class GameApp extends StatelessWidget {
  final MoonshotGame game;

  const GameApp({Key key, this.game}) : super(key: key);

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
          backgroundColor: Colors.orange,
          body: Stack(
            children: <Widget>[
              Positioned.fill(child: game.widget),
              Positioned.fill(child: GameUI()),
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
