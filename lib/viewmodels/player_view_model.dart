import 'package:flutter/foundation.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/player.dart';

class PlayerViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  PlayerViewModel(this._databaseHelper);

  List<Player> _players = [];
  bool _isLoading = false;
  String? _error;

  List<Player> get players => List.unmodifiable(_players);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _refreshPlayers(int teamId) async {
    _players = await _databaseHelper.getPlayersByTeamId(teamId);
  }

  Future<void> loadPlayers(int teamId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _refreshPlayers(teamId);
    } catch (e) {
      _error = 'Failed to load players.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlayer(Player player) async {
    _error = null;

    try {
      await _databaseHelper.insertPlayer(player);
      await _refreshPlayers(player.teamId);

      return true;
    } catch (e) {
      _error = "Can't add player.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updatePlayer(Player player) async {
    _error = null;

    try {
      await _databaseHelper.updatePlayer(player);
      await _refreshPlayers(player.teamId);

      return true;
    } catch (e) {
      _error = "Can't update player.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deletePlayer(Player player) async {
    if (player.id == null) {
      _error = 'Player ID is missing.';
      notifyListeners();
      return false;
    }

    _error = null;

    try {
      await _databaseHelper.deletePlayer(player.id!);
      await _refreshPlayers(player.teamId);

      return true;
    } catch (e) {
      _error = "Can't delete player.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<Player?> getPlayerById(int playerId) async {
    try {
      return await _databaseHelper.getPlayerById(playerId);
    } catch (e) {
      return null;
    }
  }
}
