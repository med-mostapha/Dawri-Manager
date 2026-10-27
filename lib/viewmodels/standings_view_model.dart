import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/team_standing.dart';
import '../utils/standings_calculator.dart';

class StandingsViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;
  final StandingsCalculator _calculator;

  StandingsViewModel(this._databaseHelper, {StandingsCalculator? calculator})
    : _calculator = calculator ?? StandingsCalculator();

  List<TeamStanding> _standings = [];
  bool _isLoading = false;
  String? _error;

  List<TeamStanding> get standings => List.unmodifiable(_standings);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStandings(int tournamentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final teams = await _databaseHelper.getTeamsByTournament(tournamentId);

      final matches = await _databaseHelper.getMatchesByTournament(
        tournamentId,
      );

      final finishedMatches = matches
          .where((match) => match.status.name == 'finished')
          .toList();

      final goalsLists = await Future.wait(
        finishedMatches
            .where((match) => match.id != null)
            .map((match) => _databaseHelper.getGoalsByMatch(match.id!)),
      );

      final goals = goalsLists.expand((goals) => goals).toList();

      _standings = _calculator.calculate(
        teams: teams,
        matches: matches,
        goals: goals,
      );
    } catch (e) {
      _error = 'Failed to load standings.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
