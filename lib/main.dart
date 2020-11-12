import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_store/json_store.dart';

import 'cubit/game_cubit.dart';
import 'dao/game_dao.dart';
import 'game/moonshot_game.dart';
import 'ui/game_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();

  await Flame.audio.loadAll([
    'die.wav',
    'hit.wav',
    'menu_tap.wav',
    'shoot.wav',
  ]);

  runApp(
    GameApp(
      game: MoonshotGame(
        GameCubit(GameDao(JsonStore()))..initGame(),
      ),
    ),
  );
}

class GameApp extends StatelessWidget {
  final MoonshotGame game;

  const GameApp({Key key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Retro'),
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
