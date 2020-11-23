import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flame/flame.dart';

import '../dao/game_dao.dart';
import '../services/app_ads.dart';
import '../ui/enums.dart';

part 'game_state.dart';

const Duration kLevelTimeSubtraction = Duration(seconds: 1);
const Duration kInitialLevelTime = Duration(seconds: 15);
const Duration kMinimumLevelTime = Duration(seconds: 10);
const kEnemyInitialSpawnTime = 2000;
const kPerScoreSubtractInitialTime = 10;

class GameCubit extends Cubit<GameState> {
  final Random gameRandom = Random();
  Timer _gameTime;
  Stopwatch _enemyStopwatch;
  AudioPlayer inGameMusic;

  final GameDao _storage;
  final FirebaseAnalytics firebaseAnalytics;

  int _enemySpawnTime = kEnemyInitialSpawnTime;
  int _perScoreSubtractTime = kPerScoreSubtractInitialTime;

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
    if (pause) {
      _stopGameTimer();
      _enemyStopwatch.stop();
    } else if (loadedState.inGame) {
      _startGameTimer();
      _enemyStopwatch.start();
    }
    emit(loadedState.copyWith(paused: pause));
  }

  Future<void> startGame() async {
    _enemySpawnTime = kEnemyInitialSpawnTime;
    _perScoreSubtractTime = kPerScoreSubtractInitialTime;
    emit(loadedState.copyWith(
      screen: Screen.Playing,
      score: 0,
      inGame: true,
    ));
    _startGameTimer();
    _enemyStopwatch = Stopwatch()..start();
    AppAds.showBanner();
    if (loadedState.music) {
      if (inGameMusic == null) {
        inGameMusic = await Flame.audio.loopLongAudio('playing.wav');
      } else {
        inGameMusic.resume();
      }
    }
  }

  void _startGameTimer() {
    _gameTime = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (!(state as GameLoaded).paused) {
          if (_enemyStopwatch.elapsed > Duration(milliseconds: _enemySpawnTime)) {
            emit(loadedState.copyWith(addEnemy: true));
            emit(loadedState.copyWith(addEnemy: false));
            _enemyStopwatch.reset();
          }
        }
      },
    );
  }

  void _stopGameTimer() {
    _gameTime.cancel();
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

    emit(loadedState.copyWith(
      screen: Screen.Crash,
      inGame: false,
    ));
    _stopGameTimer();
    _enemyStopwatch.stop();

    inGameMusic.stop();
    Flame.audio.play('crash.wav');
    Flame.audio.play('die.wav');
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

    Flame.audio.play('hit.wav');

    if (_enemySpawnTime > kEnemyInitialSpawnTime * 0.5) {
      _enemySpawnTime -= _perScoreSubtractTime;

      if (_enemySpawnTime < kEnemyInitialSpawnTime * 0.7) {
        _perScoreSubtractTime = 4;
      } else if (_enemySpawnTime < kEnemyInitialSpawnTime * 0.8) {
        _perScoreSubtractTime = 6;
      } else if (_enemySpawnTime < kEnemyInitialSpawnTime * 0.9) {
        _perScoreSubtractTime = 8;
      }
    }
  }

  Future<void> changeScreen(Screen screen) async {
    firebaseAnalytics.setCurrentScreen(screenName: screen.toString());
    emit(loadedState.copyWith(screen: screen));
  }

  Future<void> toggleSounds() async {
    emit(loadedState.copyWith(sounds: !loadedState.sounds));
  }

  Future<void> toggleMusic() async {
    emit(loadedState.copyWith(music: !loadedState.music));
  }
}
