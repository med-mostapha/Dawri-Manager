import 'package:flutter/foundation.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/schedule_generator.dart';

class TournamentViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  TournamentViewModel(this._databaseHelper);

  List<Tournament> _tournaments = [];

  bool _isLoading = false;
  String? _error;

  List<Tournament> get tournaments => List.unmodifiable(_tournaments);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _refreshTournaments() async {
    _tournaments = await _databaseHelper.getTournaments();
  }

  Future<void> loadTournaments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _refreshTournaments();
    } catch (e) {
      _error = 'Failed to load tournaments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTournament(Tournament t) async {
    _error = null;

    try {
      await _databaseHelper.insertTournament(t);
      await _refreshTournaments();
      return true;
    } catch (e) {
      _error = "Can't add tournament";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateTournament(
    Tournament t, {
    MatchType? originalMatchType,
  }) async {
    _error = null;

    try {
      if (t.id == null) {
        _error = 'Tournament ID is missing.';
        return false;
      }

      if (originalMatchType != null && originalMatchType != t.matchType) {
        final hasMatches = await _databaseHelper.hasMatchesForTournament(t.id!);

        if (hasMatches) {
          _error = 'You cannot change the match format after generating the schedule.';
          return false;
        }
      }

      await _databaseHelper.updateTournament(t);
      await _refreshTournaments();
      return true;
    } catch (e) {
      _error = "Can't update tournament.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> generateSchedule(Tournament tournament) async {
    _error = null;

    if (tournament.id == null) {
      _error = 'Tournament ID is missing.';
      notifyListeners();
      return false;
    }

    try {
      final existingMatches = await _databaseHelper.getMatchesByTournament(
        tournament.id!,
      );

      if (existingMatches.isNotEmpty) {
        _error = 'The schedule has already been generated.';
        return false;
      }

      final teams = await _databaseHelper.getTeamsByTournament(tournament.id!);

      if (teams.length < 2) {
        _error = 'At least two teams are required.';
        return false;
      }

      final matches = ScheduleGenerator.generate(
        tournamentId: tournament.id!,
        teamIds: teams.map((team) => team.id!).toList(),
        matchType: tournament.matchType,
      );

      await _databaseHelper.insertMatches(matches);

      return true;
    } catch (e) {
      _error = 'Failed to generate the schedule.';
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<int> deleteTournament(int id) async {
    _error = null;

    try {
      final count = await _databaseHelper.deleteTournament(id);
      if (count > 0) {
        await _refreshTournaments();
      } else {
        _error = "Tournament not found.";
      }
      return count;
    } catch (e) {
      _error = "Failed to delete tournament";
      return 0;
    } finally {
      notifyListeners();
    }
  }
}
