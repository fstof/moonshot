part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class GameLoading extends GameState {
  @override
  List<Object> get props => [];
}

class GameLoaded extends GameState {
  final int score;
  final int highScore;
  final Screen screen;
  final bool paused;
  final bool addEnemy;
  final bool inGame;
  final bool sounds;
  final bool music;

  GameLoaded({
    this.score,
    this.highScore,
    this.screen,
    this.paused,
    this.addEnemy,
    this.inGame,
    this.sounds = true,
    this.music = true,
  });

  GameLoaded copyWith({
    int score,
    int highScore,
    Screen screen,
    bool paused,
    bool addEnemy,
    bool inGame,
    bool sounds,
    bool music,
  }) =>
      GameLoaded(
        score: score ?? this.score,
        highScore: highScore ?? this.highScore,
        screen: screen ?? this.screen,
        paused: paused ?? this.paused,
        addEnemy: addEnemy ?? this.addEnemy,
        inGame: inGame ?? this.inGame,
        sounds: sounds ?? this.sounds,
        music: music ?? this.music,
      );

  @override
  List<Object> get props => [
        score,
        highScore,
        screen,
        paused,
        addEnemy,
        inGame,
        sounds,
        music,
      ];
}
