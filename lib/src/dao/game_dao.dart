import 'package:json_store/json_store.dart';

class GameDao {
  final JsonStore _storage;

  GameDao(this._storage);

  Future<int?> loadHighscore() async {
    final raw = await _storage.getItem('highscore');
    if (raw != null) {
      return raw['highscore'] as int?;
    }
    return null;
  }

  Future<void> saveHighscore(int highscore) async {
    await _storage.setItem(
      'highscore',
      {'highscore': highscore},
      encrypt: true,
    );
  }
}
