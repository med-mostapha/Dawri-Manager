import 'package:tournament_organizer/models/goal.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/team_standing.dart';

class StandingsCalculator {
  List<TeamStanding> calculate({
    required List<Team> teams,
    required List<Match> matches,
    required List<Goal> goals,
  }) {
    final standings = <int, _StandingStats>{};

    for (final team in teams) {
      if (team.id == null) {
        continue;
      }

      standings[team.id!] = _StandingStats(
        teamId: team.id!,
        teamName: team.name,
      );
    }

    final goalsByMatch = <int, List<Goal>>{};

    for (final goal in goals) {
      goalsByMatch.putIfAbsent(goal.matchId, () => []).add(goal);
    }

    for (final match in matches) {
      if (match.status != MatchStatus.finished) {
        continue;
      }

      final home = standings[match.homeTeamId];
      final away = standings[match.awayTeamId];

      if (home == null || away == null) {
        continue;
      }

      final matchGoals = goalsByMatch[match.id] ?? [];

      final homeGoals = matchGoals
          .where((goal) => goal.teamId == match.homeTeamId)
          .length;

      final awayGoals = matchGoals
          .where((goal) => goal.teamId == match.awayTeamId)
          .length;

      home.played++;
      away.played++;

      home.goalsFor += homeGoals;
      home.goalsAgainst += awayGoals;

      away.goalsFor += awayGoals;
      away.goalsAgainst += homeGoals;

      if (homeGoals > awayGoals) {
        home.won++;
        away.lost++;
        home.points += 3;
      } else if (homeGoals < awayGoals) {
        away.won++;
        home.lost++;
        away.points += 3;
      } else {
        home.drawn++;
        away.drawn++;
        home.points++;
        away.points++;
      }
    }

    final result = standings.values
        .map(
          (stats) => TeamStanding(
            teamId: stats.teamId,
            teamName: stats.teamName,
            played: stats.played,
            won: stats.won,
            drawn: stats.drawn,
            lost: stats.lost,
            goalsFor: stats.goalsFor,
            goalsAgainst: stats.goalsAgainst,
            points: stats.points,
          ),
        )
        .toList();

    result.sort((a, b) {
      final pointsComparison = b.points.compareTo(a.points);
      if (pointsComparison != 0) return pointsComparison;

      final goalDifferenceComparison = b.goalDifference.compareTo(
        a.goalDifference,
      );
      if (goalDifferenceComparison != 0) return goalDifferenceComparison;

      final goalsForComparison = b.goalsFor.compareTo(a.goalsFor);
      if (goalsForComparison != 0) return goalsForComparison;

      return a.teamName.compareTo(b.teamName);
    });

    return result;
  }
}

class _StandingStats {
  final int teamId;
  final String teamName;

  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;

  int goalsFor = 0;
  int goalsAgainst = 0;
  int points = 0;

  _StandingStats({required this.teamId, required this.teamName});
}
