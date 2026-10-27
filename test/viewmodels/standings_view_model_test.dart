import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/viewmodels/standings_view_model.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/goal.dart';

void main() {
  late Directory tempDirectory;
  late DatabaseHelper databaseHelper;
  late StandingsViewModel viewModel;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp();

    final path = join(tempDirectory.path, 'test.db');

    databaseHelper = DatabaseHelper.forTesting(path);
    viewModel = StandingsViewModel(databaseHelper);
  });

  tearDown(() async {
    viewModel.dispose();
    await databaseHelper.close();
    await tempDirectory.delete(recursive: true);
  });

  test(
    'loads an empty standings list for a tournament without teams',
    () async {
      await databaseHelper.insertTournament(
        Tournament(name: 'Test Tournament', createdAt: ''),
      );

      final tournaments = await databaseHelper.getTournaments();
      final tournamentId = tournaments.first.id!;

      await viewModel.loadStandings(tournamentId);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
      expect(viewModel.standings, isEmpty);
    },
  );

  test('calculates standings from a finished match', () async {
    // Create tournament.
    await databaseHelper.insertTournament(
      Tournament(name: 'Test Tournament', createdAt: ''),
    );

    final tournaments = await databaseHelper.getTournaments();
    final tournamentId = tournaments.first.id!;

    // Create teams.
    await databaseHelper.insertTeam(
      Team(tournamentId: tournamentId, name: 'Team A'),
    );

    await databaseHelper.insertTeam(
      Team(tournamentId: tournamentId, name: 'Team B'),
    );

    final teams = await databaseHelper.getTeamsByTournament(tournamentId);

    final teamA = teams.firstWhere((team) => team.name == 'Team A');
    final teamB = teams.firstWhere((team) => team.name == 'Team B');

    final teamAId = teamA.id!;
    final teamBId = teamB.id!;

    // Create players.
    await databaseHelper.insertPlayer(
      Player(teamId: teamAId, name: 'Player A'),
    );

    await databaseHelper.insertPlayer(
      Player(teamId: teamBId, name: 'Player B'),
    );

    final playersA = await databaseHelper.getPlayersByTeamId(teamAId);
    final playersB = await databaseHelper.getPlayersByTeamId(teamBId);

    final playerAId = playersA.first.id!;
    final playerBId = playersB.first.id!;

    // Create a scheduled match.
    final matchId = await databaseHelper.insertMatch(
      Match(
        tournamentId: tournamentId,
        homeTeamId: teamAId,
        awayTeamId: teamBId,
        roundNumber: 1,
      ),
    );

    // Add two goals for Team A and one goal for Team B.
    await databaseHelper.insertGoal(
      Goal(matchId: matchId, playerId: playerAId, teamId: teamAId),
    );

    await databaseHelper.insertGoal(
      Goal(matchId: matchId, playerId: playerAId, teamId: teamAId),
    );

    await databaseHelper.insertGoal(
      Goal(matchId: matchId, playerId: playerBId, teamId: teamBId),
    );

    // Mark the match as finished.
    await databaseHelper.updateMatch(
      Match(
        id: matchId,
        tournamentId: tournamentId,
        homeTeamId: teamAId,
        awayTeamId: teamBId,
        roundNumber: 1,
        status: MatchStatus.finished,
      ),
    );

    // Load standings.
    await viewModel.loadStandings(tournamentId);

    expect(viewModel.error, isNull);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.standings, hasLength(2));

    final standingA = viewModel.standings.firstWhere(
      (standing) => standing.teamId == teamAId,
    );

    final standingB = viewModel.standings.firstWhere(
      (standing) => standing.teamId == teamBId,
    );

    expect(standingA.played, 1);
    expect(standingA.won, 1);
    expect(standingA.goalsFor, 2);
    expect(standingA.goalsAgainst, 1);
    expect(standingA.goalDifference, 1);
    expect(standingA.points, 3);

    expect(standingB.played, 1);
    expect(standingB.lost, 1);
    expect(standingB.goalsFor, 1);
    expect(standingB.goalsAgainst, 2);
    expect(standingB.goalDifference, -1);
    expect(standingB.points, 0);

    expect(viewModel.standings.first.teamId, teamAId);
  });
}
