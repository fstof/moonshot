import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game_cubit.dart';
import '../services/app_ads.dart';
import 'crash_screen.dart';
import 'enums.dart';
import 'home_screen.dart';
import 'playing_screen.dart';

class GameUI extends StatefulWidget {
  const GameUI() : super();

  @override
  _GameUIState createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> with WidgetsBindingObserver {
  GameCubit _gameBloc;

  @override
  void initState() {
    super.initState();
    _gameBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addObserver(this);
    AppAds.init(_gameBloc);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    AppAds.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState is now: $state');

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _gameBloc.pauseGameToggle(true);
    } else if (state == AppLifecycleState.resumed) {
      _gameBloc.pauseGameToggle(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: BlocBuilder<GameCubit, GameState>(
              cubit: _gameBloc,
              builder: (context, state) {
                if (state is GameLoading) {
                  return const Offstage();
                }
                if (state is GameLoaded) {
                  if (state.screen == Screen.Home) {
                    return HomeScreen();
                  }
                  if (state.screen == Screen.Playing) {
                    return PlayingScreen();
                  }
                  if (state.screen == Screen.Crash) {
                    return CrashScreen();
                  }
                }
                return Offstage();
              }),
        ),
      ),
    );
  }
}
