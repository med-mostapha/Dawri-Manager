import 'package:flutter/foundation.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/team.dart';

class TeamViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  TeamViewModel(this._databaseHelper);

  List<Team> _teams = [];
  Map<int, int> _playerCounts = {};
  bool _isLoading = false;
  String? _error;

  List<Team> get teams => List.unmodifiable(_teams);
  int playerCount(int teamId) => _playerCounts[teamId] ?? 0;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _refreshTeams(int tournamentId) async {
    _teams = await _databaseHelper.getTeamsByTournament(tournamentId);
  }

  int _loadRequestId = 0;

  Future<void> loadTeams(int tournamentId) async {
    final requestId = ++_loadRequestId;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final teams = await _databaseHelper.getTeamsByTournament(tournamentId);
      final playerCounts = await _databaseHelper.getPlayerCountsByTeam();

      if (requestId != _loadRequestId) return;

      _teams = teams;
      _playerCounts = playerCounts;
    } catch (e) {
      if (requestId != _loadRequestId) return;

      _error = 'Failed to load teams.';
    } finally {
      if (requestId == _loadRequestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addTeam(Team team) async {
    if (!await _ensureTeamsCanBeModified(team.tournamentId)) {
      return false;
    }
    try {
      await _databaseHelper.insertTeam(team);
      await _refreshTeams(team.tournamentId);
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateTeam(Team team) async {
    try {
      await _databaseHelper.updateTeam(team);
      await _refreshTeams(team.tournamentId);
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<int> deleteTeam(Team team) async {
    if (!await _ensureTeamsCanBeModified(team.tournamentId)) {
      return 0;
    }
    _error = null;

    if (team.id == null) {
      _error = 'Team ID is missing.';
      notifyListeners();
      return 0;
    }

    try {
      final count = await _databaseHelper.deleteTeam(team.id!);
      if (count > 0) {
        await _refreshTeams(team.tournamentId);
      } else {
        _error = "Team not found";
      }

      return count;
    } catch (e) {
      _error = "Failed to delete Team";
      return 0;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> canModifyTeams(int tournamentId) async {
    return !(await _databaseHelper.hasMatchesForTournament(tournamentId));
  }

  Future<bool> _ensureTeamsCanBeModified(int tournamentId) async {
    final hasMatches = await _databaseHelper.hasMatchesForTournament(
      tournamentId,
    );

    if (hasMatches) {
      _error = 'Teams cannot be changed after the schedule has been generated.';
      return false;
    }

    _error = null;
    return true;
  }
}
