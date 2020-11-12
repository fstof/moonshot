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

  GameLoaded({
    this.score,
    this.highScore,
    this.screen,
    this.paused,
  });

  GameLoaded copyWith({
    int score,
    int highScore,
    Screen screen,
    bool paused,
  }) =>
      GameLoaded(
        score: score ?? this.score,
        highScore: highScore ?? this.highScore,
        screen: screen ?? this.screen,
        paused: paused ?? this.paused,
      );

  @override
  List<Object> get props => [
        score,
        highScore,
        screen,
        paused,
      ];
}
