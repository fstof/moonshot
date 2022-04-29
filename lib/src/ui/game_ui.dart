import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game_cubit.dart';
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
  late GameCubit _gameBloc;

  @override
  void initState() {
    super.initState();
    _gameBloc = BlocProvider.of(context);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState is now: $state');

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _gameBloc.pauseGameToggle(true);
    } else if (state == AppLifecycleState.resumed) {
      _gameBloc.pauseGameToggle(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: BlocBuilder<GameCubit, GameState>(
            bloc: _gameBloc,
            builder: (context, state) {
              if (state is GameLoading) {
                return const Offstage();
              }
              if (state is GameLoaded) {
                if (state.screen == Screen.Home) {
                  return HomeScreen(buttonSprites: state.buttonSprites);
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
    );
  }
}
