import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_organizer/models/goal.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';

import 'package:tournament_organizer/utils/standings_calculator.dart';

void main() {
  late StandingsCalculator calculator;
  late List<Team> teams;
  late List<Match> matches;
  late List<Goal> goals;

  setUp(() {
    calculator = StandingsCalculator();

    teams = [
      Team(id: 1, tournamentId: 1, name: 'Team A'),
      Team(id: 2, tournamentId: 1, name: 'Team B'),
      Team(id: 3, tournamentId: 1, name: 'Team C'),
    ];

    matches = [
      Match(
        id: 1,
        tournamentId: 1,
        homeTeamId: 1,
        awayTeamId: 2,
        roundNumber: 1,
        status: MatchStatus.finished,
      ),
      Match(
        id: 2,
        tournamentId: 1,
        homeTeamId: 2,
        awayTeamId: 3,
        roundNumber: 2,
        status: MatchStatus.finished,
      ),
      Match(
        id: 3,
        tournamentId: 1,
        homeTeamId: 1,
        awayTeamId: 3,
        roundNumber: 3,
        status: MatchStatus.scheduled,
      ),
    ];

    goals = [
      // Team A beats Team B 2-1.
      const Goal(matchId: 1, playerId: 1, teamId: 1),
      const Goal(matchId: 1, playerId: 1, teamId: 1),
      const Goal(matchId: 1, playerId: 2, teamId: 2),

      // Team B draws with Team C 1-1.
      const Goal(matchId: 2, playerId: 2, teamId: 2),
      const Goal(matchId: 2, playerId: 3, teamId: 3),

      // The scheduled match has no effect on standings.
      const Goal(matchId: 3, playerId: 1, teamId: 1),
    ];
  });

  test('calculates points and match statistics correctly', () {
    final standings = calculator.calculate(
      teams: teams,
      matches: matches,
      goals: goals,
    );

    final teamA = standings.firstWhere((team) => team.teamId == 1);
    final teamB = standings.firstWhere((team) => team.teamId == 2);
    final teamC = standings.firstWhere((team) => team.teamId == 3);

    expect(teamA.played, 1);
    expect(teamA.won, 1);
    expect(teamA.drawn, 0);
    expect(teamA.lost, 0);
    expect(teamA.goalsFor, 2);
    expect(teamA.goalsAgainst, 1);
    expect(teamA.goalDifference, 1);
    expect(teamA.points, 3);

    expect(teamB.played, 2);
    expect(teamB.won, 0);
    expect(teamB.drawn, 1);
    expect(teamB.lost, 1);
    expect(teamB.goalsFor, 2);
    expect(teamB.goalsAgainst, 3);
    expect(teamB.goalDifference, -1);
    expect(teamB.points, 1);

    expect(teamC.played, 1);
    expect(teamC.won, 0);
    expect(teamC.drawn, 1);
    expect(teamC.lost, 0);
    expect(teamC.goalsFor, 1);
    expect(teamC.goalsAgainst, 1);
    expect(teamC.points, 1);
  });

  test('sorts teams by points and goal difference', () {
    final standings = calculator.calculate(
      teams: teams,
      matches: matches,
      goals: goals,
    );

    expect(standings.map((team) => team.teamId).toList(), [1, 3, 2]);
  });

  test('includes teams that have not played any finished matches', () {
    final standings = calculator.calculate(
      teams: teams,
      matches: [],
      goals: [],
    );

    expect(standings, hasLength(3));

    for (final team in standings) {
      expect(team.played, 0);
      expect(team.points, 0);
    }
  });

  test('excludes a reopened match from standings', () {
    final reopenedMatches = matches.map((match) {
      if (match.id == 1) {
        return match.copyWith(status: MatchStatus.scheduled);
      }
      return match;
    }).toList();

    final standings = calculator.calculate(
      teams: teams,
      matches: reopenedMatches,
      goals: goals,
    );

    final teamA = standings.firstWhere((team) => team.teamId == 1);
    final teamB = standings.firstWhere((team) => team.teamId == 2);

    expect(teamA.played, 0);
    expect(teamA.points, 0);

    expect(teamB.played, 1);
    expect(teamB.points, 1);
  });

  test('uses goals scored to break a tie in points and goal difference', () {
    final tieMatches = [
      Match(
        id: 10,
        tournamentId: 1,
        homeTeamId: 1,
        awayTeamId: 2,
        roundNumber: 1,
        status: MatchStatus.finished,
      ),
      Match(
        id: 11,
        tournamentId: 1,
        homeTeamId: 2,
        awayTeamId: 3,
        roundNumber: 2,
        status: MatchStatus.finished,
      ),
    ];

    final tieGoals = [
      const Goal(matchId: 11, playerId: 2, teamId: 2),
      const Goal(matchId: 11, playerId: 2, teamId: 2),
      const Goal(matchId: 11, playerId: 2, teamId: 2),
      const Goal(matchId: 11, playerId: 2, teamId: 2),
      const Goal(matchId: 11, playerId: 3, teamId: 3),
      const Goal(matchId: 11, playerId: 3, teamId: 3),
    ];

    final standings = calculator.calculate(
      teams: teams,
      matches: tieMatches,
      goals: tieGoals,
    );

    // Teams A and B have 3 points and a goal difference of +2.
    // Team B scored more goals, so it ranks first.
    expect(standings.map((team) => team.teamId).toList(), [2, 1, 3]);
  });

  test('counts a match without goals as a draw', () {
    final zeroZeroMatch = [
      Match(
        id: 20,
        tournamentId: 1,
        homeTeamId: 1,
        awayTeamId: 2,
        roundNumber: 1,
        status: MatchStatus.finished,
      ),
    ];

    final standings = calculator.calculate(
      teams: teams,
      matches: zeroZeroMatch,
      goals: [],
    );

    final teamA = standings.firstWhere((team) => team.teamId == 1);
    final teamB = standings.firstWhere((team) => team.teamId == 2);

    expect(teamA.played, 1);
    expect(teamA.drawn, 1);
    expect(teamA.points, 1);
    expect(teamA.goalsFor, 0);
    expect(teamA.goalsAgainst, 0);

    expect(teamB.played, 1);
    expect(teamB.drawn, 1);
    expect(teamB.points, 1);
  });
}
