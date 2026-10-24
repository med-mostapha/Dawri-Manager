import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/utils/date_utils.dart';

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

  Future<int> createTournament(String name) async {
    await databaseHelper.insertTournament(
      Tournament(name: name, createdAt: getNow()),
    );

    final tournaments = await databaseHelper.getTournaments();

    return tournaments.singleWhere((t) => t.name == name).id!;
  }

  Future<int> createTeam(int tournamentId, String name) async {
    await databaseHelper.insertTeam(
      Team(tournamentId: tournamentId, name: name),
    );

    final teams = await databaseHelper.getTeamsByTournament(tournamentId);

    return teams.singleWhere((t) => t.name == name).id!;
  }

  test('Tournament CRUD works correctly', () async {
    final firstId = await createTournament('League A');
    await createTournament('League B');

    var tournaments = await databaseHelper.getTournaments();

    expect(tournaments.length, 2);

    await databaseHelper.updateTournament(
      Tournament(id: firstId, name: 'Updated League A', createdAt: getNow()),
    );

    tournaments = await databaseHelper.getTournaments();

    expect(tournaments.length, 2);
    expect(tournaments.any((t) => t.name == 'Updated League A'), isTrue);
    expect(tournaments.any((t) => t.name == 'League B'), isTrue);

    await databaseHelper.deleteTournament(firstId);

    tournaments = await databaseHelper.getTournaments();

    expect(tournaments.length, 1);
    expect(tournaments.single.name, 'League B');
  });

  test('Teams belong to the correct tournament', () async {
    final tournamentA = await createTournament('League A');
    final tournamentB = await createTournament('League B');

    final teamA = await createTeam(tournamentA, 'Lions');
    await createTeam(tournamentA, 'Eagles');
    await createTeam(tournamentB, 'Tigers');

    final teamsA = await databaseHelper.getTeamsByTournament(tournamentA);
    final teamsB = await databaseHelper.getTeamsByTournament(tournamentB);

    expect(teamsA.length, 2);
    expect(teamsB.length, 1);
    expect(teamsB.single.name, 'Tigers');

    await databaseHelper.updateTeam(
      Team(id: teamA, tournamentId: tournamentA, name: 'Updated Lions'),
    );

    final updatedTeams = await databaseHelper.getTeamsByTournament(tournamentA);

    expect(updatedTeams.any((t) => t.name == 'Updated Lions'), isTrue);
    expect(updatedTeams.length, 2);

    await databaseHelper.deleteTeam(teamA);

    final remainingTeams = await databaseHelper.getTeamsByTournament(
      tournamentA,
    );

    expect(remainingTeams.length, 1);
    expect(remainingTeams.single.name, 'Eagles');
  });

  test('Player CRUD works correctly', () async {
    final tournamentId = await createTournament('League A');
    final teamId = await createTeam(tournamentId, 'Lions');

    await databaseHelper.insertPlayer(
      Player(teamId: teamId, name: 'Ahmed', age: 20),
    );

    await databaseHelper.insertPlayer(
      Player(teamId: teamId, name: 'Mohamed', age: null),
    );

    var players = await databaseHelper.getPlayersByTeamId(teamId);

    expect(players.length, 2);
    expect(players.any((p) => p.name == 'Ahmed' && p.age == 20), isTrue);
    expect(players.any((p) => p.name == 'Mohamed' && p.age == null), isTrue);

    final ahmed = players.singleWhere((p) => p.name == 'Ahmed');

    await databaseHelper.updatePlayer(
      Player(id: ahmed.id, teamId: teamId, name: 'Ahmed Updated', age: 21),
    );

    players = await databaseHelper.getPlayersByTeamId(teamId);

    expect(players.length, 2);
    expect(
      players.any((p) => p.name == 'Ahmed Updated' && p.age == 21),
      isTrue,
    );

    await databaseHelper.deletePlayer(ahmed.id!);

    players = await databaseHelper.getPlayersByTeamId(teamId);

    expect(players.length, 1);
    expect(players.single.name, 'Mohamed');
  });

  test('Deleting a tournament cascades to its teams and players', () async {
    final tournamentId = await createTournament('League A');
    final teamId = await createTeam(tournamentId, 'Lions');

    await databaseHelper.insertPlayer(
      Player(teamId: teamId, name: 'Ahmed', age: 20),
    );

    await databaseHelper.deleteTournament(tournamentId);

    final teams = await databaseHelper.getTeamsByTournament(tournamentId);
    final players = await databaseHelper.getPlayersByTeamId(teamId);
    final tournaments = await databaseHelper.getTournaments();

    expect(tournaments, isEmpty);
    expect(teams, isEmpty);
    expect(players, isEmpty);
  });

  test('Duplicate team names are rejected within one tournament', () async {
    final tournamentId = await createTournament('League A');

    await createTeam(tournamentId, 'Lions');

    expect(
      () => databaseHelper.insertTeam(
        Team(tournamentId: tournamentId, name: 'Lions'),
      ),
      throwsA(isA<DatabaseException>()),
    );
  });
}
