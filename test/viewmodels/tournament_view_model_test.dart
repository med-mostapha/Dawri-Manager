import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/date_utils.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late TournamentViewModel viewModel;
  late Directory tempDirectory;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp();
    final path = join(tempDirectory.path, 'test.db');

    databaseHelper = DatabaseHelper.forTesting(path);
    viewModel = TournamentViewModel(databaseHelper);
  });

  tearDown(() async {
    viewModel.dispose();
    await databaseHelper.close();
    await tempDirectory.delete(recursive: true);
  });

  Future<Tournament> createTournament() async {
    final tournament = Tournament(name: 'League A', createdAt: getNow());

    await databaseHelper.insertTournament(tournament);

    final tournaments = await databaseHelper.getTournaments();
    return tournaments.single;
  }

  Future<void> createTeams(int tournamentId, int count) async {
    final names = ['Lions', 'Eagles', 'Tigers', 'Wolves', 'Bears'];

    for (var i = 0; i < count; i++) {
      await databaseHelper.insertTeam(
        Team(tournamentId: tournamentId, name: names[i]),
      );
    }
  }

  test('generates and saves the schedule successfully', () async {
    final tournament = await createTournament();
    await createTeams(tournament.id!, 4);

    final success = await viewModel.generateSchedule(tournament);

    final matches = await databaseHelper.getMatchesByTournament(tournament.id!);

    expect(success, isTrue);
    expect(matches.length, 12);
    expect(viewModel.error, isNull);
  });

  test('rejects schedule generation with fewer than two teams', () async {
    final tournament = await createTournament();
    await createTeams(tournament.id!, 1);

    final success = await viewModel.generateSchedule(tournament);

    expect(success, isFalse);
    expect(viewModel.error, 'At least two teams are required.');
  });

  test('prevents generating the schedule twice', () async {
    final tournament = await createTournament();
    await createTeams(tournament.id!, 4);

    final firstAttempt = await viewModel.generateSchedule(tournament);
    final secondAttempt = await viewModel.generateSchedule(tournament);

    final matches = await databaseHelper.getMatchesByTournament(tournament.id!);

    expect(firstAttempt, isTrue);
    expect(secondAttempt, isFalse);
    expect(matches.length, 12);
    expect(viewModel.error, 'The schedule has already been generated.');
  });
}
