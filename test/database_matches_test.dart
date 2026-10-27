import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/date_utils.dart';
import 'package:tournament_organizer/utils/schedule_generator.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late Directory tempDirectory;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp();

    final path = join(tempDirectory.path, 'test.db');
    databaseHelper = DatabaseHelper.forTesting(path);
  });

  tearDown(() async {
    await databaseHelper.close();
    await tempDirectory.delete(recursive: true);
  });

  Future<int> createTournament() async {
    await databaseHelper.insertTournament(
      Tournament(name: 'League A', createdAt: getNow()),
    );

    final tournaments = await databaseHelper.getTournaments();
    return tournaments.single.id!;
  }

  Future<List<int>> createTeams(int tournamentId) async {
    final teamNames = ['Lions', 'Eagles', 'Tigers', 'Wolves'];

    for (final name in teamNames) {
      await databaseHelper.insertTeam(
        Team(tournamentId: tournamentId, name: name),
      );
    }

    final teams = await databaseHelper.getTeamsByTournament(tournamentId);

    return teams.map((team) => team.id!).toList();
  }

  test('inserts and retrieves all generated matches', () async {
    final tournamentId = await createTournament();
    final teamIds = await createTeams(tournamentId);

    final matches = ScheduleGenerator.generate(
      tournamentId: tournamentId,
      teamIds: teamIds,
      matchType: MatchType.singleRound,
    );

    expect(matches.length, 6);

    await databaseHelper.insertMatches(matches);

    final savedMatches = await databaseHelper.getMatchesByTournament(
      tournamentId,
    );

    expect(savedMatches.length, 6);
    expect(
      savedMatches.every((match) => match.tournamentId == tournamentId),
      isTrue,
    );
    expect(savedMatches.every((match) => match.id != null), isTrue);
  });

  test('does not insert matches for another tournament', () async {
    final tournamentA = await createTournament();

    await databaseHelper.insertTournament(
      Tournament(name: 'League B', createdAt: getNow()),
    );

    final tournaments = await databaseHelper.getTournaments();
    final tournamentB = tournaments
        .singleWhere((tournament) => tournament.name == 'League B')
        .id!;

    final teamIds = await createTeams(tournamentA);

    final matches = ScheduleGenerator.generate(
      tournamentId: tournamentA,
      teamIds: teamIds,
      matchType: MatchType.singleRound,
    );

    await databaseHelper.insertMatches(matches);

    final matchesA = await databaseHelper.getMatchesByTournament(tournamentA);
    final matchesB = await databaseHelper.getMatchesByTournament(tournamentB);

    expect(matchesA.length, 6);
    expect(matchesB, isEmpty);
  });

  test('insertMatches accepts an empty list', () async {
    await expectLater(databaseHelper.insertMatches([]), completes);
  });
}
