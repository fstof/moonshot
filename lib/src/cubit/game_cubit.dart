import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../dao/game_dao.dart';
import '../services/app_ads.dart';
import '../ui/enums.dart';

part 'game_state.dart';

const Duration kLevelTimeSubtraction = Duration(seconds: 1);
const Duration kInitialLevelTime = Duration(seconds: 15);
const Duration kMinimumLevelTime = Duration(seconds: 10);

class GameCubit extends Cubit<GameState> {
  final Random gameRandom = Random();

  final GameDao _storage;
  final FirebaseAnalytics firebaseAnalytics;

  GameCubit(this._storage, this.firebaseAnalytics) : super(GameLoading());

  GameLoaded get loadedState => state as GameLoaded;

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
    emit(loadedState.copyWith(paused: pause));
  }

  Future<void> startGame() async {
    emit(loadedState.copyWith(
      screen: Screen.Playing,
      score: 0,
    ));
    AppAds.showBanner();
  }

  Future<void> retryGame() async {
    firebaseAnalytics.logEvent(
      name: 'retry',
      parameters: {
        'score': loadedState.score,
      },
    );

    startGame();
  }

  Future<void> crash() async {
    AppAds.hideBanner();

    firebaseAnalytics.logPostScore(score: loadedState.score);

    await _storage.saveHighscore(loadedState.highScore);

    emit(loadedState.copyWith(screen: Screen.Crash));
  }

  Future<void> addScore() async {
    int highScore = loadedState.highScore;
    int newScore = loadedState.score + 1;
    if (newScore > highScore) {
      highScore = newScore;
    }

    emit(loadedState.copyWith(
      score: newScore,
      highScore: highScore,
    ));
  }

  Future<void> changeScreen(Screen screen) async {
    firebaseAnalytics.setCurrentScreen(screenName: screen.toString());
    emit(loadedState.copyWith(screen: screen));
  }
}
