import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/match.dart';
import '../models/top_scorer.dart';

class TopScorersViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  TopScorersViewModel(this._databaseHelper);

  List<TopScorer> _topScorers = [];
  bool _isLoading = false;
  String? _error;

  List<TopScorer> get topScorers => List.unmodifiable(_topScorers);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTopScorers(int tournamentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final teams = await _databaseHelper.getTeamsByTournament(tournamentId);

      final matches = await _databaseHelper.getMatchesByTournament(
        tournamentId,
      );

      final finishedMatches = matches
          .where((match) => match.status == MatchStatus.finished)
          .where((match) => match.id != null)
          .toList();

      final goalsLists = await Future.wait(
        finishedMatches.map(
          (match) => _databaseHelper.getGoalsByMatch(match.id!),
        ),
      );

      final goals = goalsLists.expand((list) => list).toList();

      final goalCounts = <int, int>{};

      for (final goal in goals) {
        goalCounts.update(
          goal.playerId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      final playersById = {};
      final scorers = <TopScorer>[];

      for (final team in teams) {
        if (team.id == null) continue;

        final players = await _databaseHelper.getPlayersByTeamId(team.id!);

        for (final player in players) {
          if (player.id == null) continue;

          playersById[player.id!] = player;
        }
      }

      final teamsById = {
        for (final team in teams)
          if (team.id != null) team.id!: team,
      };

      for (final entry in goalCounts.entries) {
        final player = playersById[entry.key];

        if (player == null) continue;

        final team = teamsById[player.teamId];

        if (team == null) continue;

        scorers.add(
          TopScorer(
            playerId: player.id!,
            playerName: player.name,
            teamId: team.id!,
            teamName: team.name,
            goals: entry.value,
          ),
        );
      }

      scorers.sort((a, b) {
        final goalsComparison = b.goals.compareTo(a.goals);

        if (goalsComparison != 0) return goalsComparison;

        final nameComparison = a.playerName.compareTo(b.playerName);

        if (nameComparison != 0) return nameComparison;

        return a.teamName.compareTo(b.teamName);
      });

      _topScorers = scorers;
    } catch (e) {
      _error = 'Failed to load top scorers.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
