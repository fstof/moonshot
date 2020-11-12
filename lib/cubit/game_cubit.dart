import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../dao/game_dao.dart';
import '../ui/enums.dart';

part 'game_state.dart';

const Duration kLevelTimeSubtraction = Duration(seconds: 1);
const Duration kInitialLevelTime = Duration(seconds: 15);
const Duration kMinimumLevelTime = Duration(seconds: 10);

class GameCubit extends Cubit<GameState> {
  final Random gameRandom = Random();

  final GameDao _storage;

  GameCubit(
    this._storage,
  ) : super(GameLoading());

  Future<void> initGame() async {
    final highscore = await _storage.loadHighscore() ?? 0;

    emit(GameLoaded(
      highScore: highscore,
      score: 0,
      screen: Screen.Home,
      paused: false,
    ));
  }

  Future<void> pauseGameToggle(bool pause) async {
    if (state is GameLoaded) {
      final st = state as GameLoaded;
      emit(st.copyWith(paused: pause));
    }
  }

  Future<void> startGame() async {
    if (state is GameLoaded) {
      final st = state as GameLoaded;
      emit(st.copyWith(
        screen: Screen.Playing,
        score: 0,
      ));
    }
  }

  Future<void> retryGame() async {
    startGame();
  }

  Future<void> crash() async {
    if (state is GameLoaded) {
      final st = state as GameLoaded;

      await _storage.saveHighscore(st.highScore);

      emit(st.copyWith(screen: Screen.Crash));
    }
  }

  Future<void> addScore() async {
    if (state is GameLoaded) {
      final st = state as GameLoaded;
      int highScore = st.highScore;
      int newScore = st.score + 1;
      if (newScore > highScore) {
        highScore = newScore;
      }

      emit(st.copyWith(
        score: newScore,
        highScore: highScore,
      ));
    }
  }

  Future<void> changeScreen(Screen screen) async {
    if (state is GameLoaded) {
      final st = state as GameLoaded;
      emit(st.copyWith(screen: screen));
    }
  }
}
