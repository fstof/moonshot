part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class GameLoading extends GameState {
  @override
  List<Object> get props => [];
}

class GameLoaded extends GameState {
  final int? score;
  final int? highScore;
  final Screen screen;
  final bool paused;
  final bool? addEnemy;
  final bool inGame;
  final bool sounds;
  final bool music;
  final SpriteSheet? buttonSprites;

  GameLoaded({
    this.score,
    this.highScore,
    required this.screen,
    required this.paused,
    this.addEnemy,
    this.inGame = false,
    this.sounds = true,
    this.music = true,
    this.buttonSprites,
  });

  GameLoaded copyWith({
    int? score,
    int? highScore,
    Screen? screen,
    bool? paused,
    bool? addEnemy,
    bool? inGame,
    bool? sounds,
    bool? music,
    SpriteSheet? buttonSprites,
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
        buttonSprites: buttonSprites ?? this.buttonSprites,
      );

  @override
  List<Object?> get props => [
        score,
        highScore,
        screen,
        paused,
        addEnemy,
        inGame,
        sounds,
        music,
        buttonSprites,
      ];
}
