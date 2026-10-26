import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/goal.dart';

class DatabaseHelper {
  // static Database? _db;
  Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._constructor();
  String? _testDatabasePath;

  final String _tournamentsTableName = 'tournaments',
      _tournamentIdColumn = 'id',
      _tournamentNameColumn = 'name',
      _tournamentCreatedAtColumn = 'created_at',
      _tournamentMatchType = 'match_type';

  final String _teamsTableName = 'teams',
      _teamIdColumn = 'id',
      _teamNameColumn = 'name',
      _teamTournamentIdColumn = 'tournament_id';

  final String _playersTableName = 'players',
      _playerIdColumn = 'id',
      _playerNameColumn = 'name',
      _playerTeamIdColumn = 'team_id',
      _playerAgeColumn = 'age';

  final String _matchesTableName = 'matches',
      _matchIdColumn = 'id',
      _matchTournamentIdColumn = 'tournament_id',
      _matchHomeTeamIdColumn = 'home_team_id',
      _matchAwayTeamIdColumn = 'away_team_id',
      _matchRoundNumberColumn = 'round_number',
      _matchScheduledAtColumn = 'scheduled_at',
      _matchStatusColumn = 'status';

  final String _goalsTableName = 'goals',
      _goalIdColumn = 'id',
      _goalMatchIdColumn = 'match_id',
      _goalPlayerIdColumn = 'player_id',
      _goalTeamIdColumn = 'team_id',
      _goalMinuteColumn = 'minute';

  DatabaseHelper._constructor();

  DatabaseHelper.forTesting(String path) {
    _testDatabasePath = path;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath =
        _testDatabasePath ?? join(databaseDirPath, 'tournament_organizer.db');

    final database = await openDatabase(
      databasePath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tournamentsTableName (
          $_tournamentIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_tournamentNameColumn TEXT NOT NULL,
          $_tournamentCreatedAtColumn TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          $_tournamentMatchType TEXT NOT NULL DEFAULT 'homeAndAway'
          CHECK ($_tournamentMatchType IN ('singleRound', 'homeAndAway'))
        );
      ''');

        await db.execute('''
        CREATE TABLE $_teamsTableName (
          $_teamIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_teamTournamentIdColumn INTEGER NOT NULL,
          $_teamNameColumn TEXT NOT NULL,

          FOREIGN KEY ($_teamTournamentIdColumn)
          REFERENCES tournaments($_tournamentIdColumn)
          ON DELETE CASCADE,

          UNIQUE ($_teamTournamentIdColumn, $_teamNameColumn)
        );
      ''');

        await db.execute('''
        CREATE TABLE $_playersTableName (
          $_playerIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_playerTeamIdColumn INTEGER NOT NULL,
          $_playerNameColumn TEXT NOT NULL,
          $_playerAgeColumn INTEGER,

          FOREIGN KEY ($_playerTeamIdColumn)
          REFERENCES teams($_teamIdColumn)
          ON DELETE CASCADE
        );
      ''');

        await db.execute('''
        CREATE TABLE $_matchesTableName (
          $_matchIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_matchTournamentIdColumn INTEGER NOT NULL,
          $_matchHomeTeamIdColumn INTEGER NOT NULL,
          $_matchAwayTeamIdColumn INTEGER NOT NULL,
          $_matchRoundNumberColumn INTEGER NOT NULL,
          $_matchScheduledAtColumn TEXT,
          $_matchStatusColumn TEXT NOT NULL DEFAULT 'scheduled',

          FOREIGN KEY ($_matchTournamentIdColumn)
          REFERENCES tournaments($_tournamentIdColumn)
          ON DELETE CASCADE,

          FOREIGN KEY ($_matchHomeTeamIdColumn)
          REFERENCES teams($_teamIdColumn)
          ON DELETE RESTRICT,

          FOREIGN KEY ($_matchAwayTeamIdColumn)
          REFERENCES teams($_teamIdColumn)
          ON DELETE RESTRICT,

          CHECK ($_matchHomeTeamIdColumn != $_matchAwayTeamIdColumn),

          CHECK ($_matchRoundNumberColumn > 0),

          CHECK (
            $_matchStatusColumn IN ('scheduled', 'finished')
          )
        );
      ''');

        await db.execute('''
        CREATE TABLE $_goalsTableName (
          $_goalIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_goalMatchIdColumn INTEGER NOT NULL,
          $_goalPlayerIdColumn INTEGER NOT NULL,
          $_goalTeamIdColumn INTEGER NOT NULL,
          $_goalMinuteColumn INTEGER,

          FOREIGN KEY ($_goalMatchIdColumn)
          REFERENCES matches($_matchIdColumn)
          ON DELETE CASCADE,

          FOREIGN KEY ($_goalPlayerIdColumn)
          REFERENCES players($_playerIdColumn)
          ON DELETE RESTRICT,

          FOREIGN KEY ($_goalTeamIdColumn)
          REFERENCES teams($_teamIdColumn)
          ON DELETE RESTRICT,

          CHECK (
            $_goalMinuteColumn IS NULL OR $_goalMinuteColumn >= 0
          )
        );
      ''');

        await db.execute('''
        CREATE INDEX idx_teams_tournament_id
        ON $_teamsTableName($_teamTournamentIdColumn);
      ''');

        await db.execute('''
        CREATE INDEX idx_players_team_id
        ON $_playersTableName($_playerTeamIdColumn);
      ''');

        await db.execute('''
        CREATE INDEX idx_matches_tournament_round
        ON $_matchesTableName(
          $_matchTournamentIdColumn,
          $_matchRoundNumberColumn
        );
      ''');

        await db.execute('''
        CREATE INDEX idx_goals_match_id
        ON $_goalsTableName($_goalMatchIdColumn);
      ''');

        await db.execute('''
        CREATE INDEX idx_goals_player_id
        ON $_goalsTableName($_goalPlayerIdColumn);
      ''');
      },
    );

    return database;
  }

  // Tournament CRUD
  Future<void> insertTournament(Tournament t) async {
    final db = await database;
    await db.insert(_tournamentsTableName, {
      _tournamentNameColumn: t.name,
      _tournamentCreatedAtColumn: t.createdAt,
      _tournamentMatchType: t.matchType.name,
    });
  }

  Future<List<Tournament>> getTournaments() async {
    final db = await database;
    final List data = await db.query(_tournamentsTableName);
    List<Tournament> tournament = data
        .map((v) => Tournament.fromMap(v))
        .toList();

    // ignore: avoid_print
    return tournament;
  }

  Future<void> updateTournament(Tournament t) async {
    final db = await database;
    await db.update(
      _tournamentsTableName,
      {_tournamentNameColumn: t.name, _tournamentMatchType: t.matchType.name},
      where: '$_tournamentIdColumn = ?',
      whereArgs: [t.id],
    );
  }

  Future<int> deleteTournament(int id) async {
    final db = await database;
    final count = await db.delete(
      _tournamentsTableName,
      where: '$_tournamentIdColumn = ?',
      whereArgs: [id],
    );
    return count;
  }

  // Team CRUD
  Future<void> insertTeam(Team team) async {
    final db = await database;
    await db.insert(_teamsTableName, {
      _teamNameColumn: team.name,
      _teamTournamentIdColumn: team.tournamentId,
    });
  }

  // Future<List<Team>> getTeams() async {
  //   final db = await database;
  //   List data = await db.query(_teamsTableName);
  //   List<Team> teams = data.map((team) => Team.fromMap(team)).toList();
  //   return teams;
  // }

  Future<List<Team>> getTeamsByTournament(int tournamentId) async {
    final db = await database;
    final List<Map<String, Object?>> data = await db.query(
      _teamsTableName,
      where: '$_teamTournamentIdColumn = ?',
      whereArgs: [tournamentId],
    );

    return data.map((row) => Team.fromMap(row)).toList();
  }

  Future<void> updateTeam(Team team) async {
    final db = await database;
    await db.update(
      _teamsTableName,
      {_teamNameColumn: team.name},
      where: '$_teamIdColumn = ?',
      whereArgs: [team.id],
    );
  }

  Future<int> deleteTeam(int id) async {
    final db = await database;
    final count = await db.delete(
      _teamsTableName,
      where: '$_teamIdColumn = ?',
      whereArgs: [id],
    );
    return count;
  }

  // Player CRUD
  Future<void> insertPlayer(Player p) async {
    final db = await database;
    await db.insert(_playersTableName, {
      _playerNameColumn: p.name,
      _playerAgeColumn: p.age,
      _playerTeamIdColumn: p.teamId,
    });
  }

  Future<List<Player>> getPlayersByTeamId(int teamId) async {
    final db = await database;
    final List data = await db.query(
      _playersTableName,
      where: '$_playerTeamIdColumn = ?',
      whereArgs: [teamId],
    );
    List<Player> player = data.map((p) => Player.fromMap(p)).toList();
    return player;
  }

  Future<void> updatePlayer(Player p) async {
    final db = await database;
    await db.update(
      _playersTableName,
      {_playerNameColumn: p.name, _playerAgeColumn: p.age},
      where: '$_playerIdColumn = ?',
      whereArgs: [p.id],
    );
  }

  Future<void> deletePlayer(int id) async {
    final db = await database;
    await db.delete(
      _playersTableName,
      where: '$_playerIdColumn = ?',
      whereArgs: [id],
    );
  }

  // Match CRUD
  Future<int> insertMatch(Match match) async {
    final db = await getDatabase();

    final matchData = match.toMap()..remove('id');

    return await db.insert(
      _matchesTableName,
      matchData,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Match>> getMatchesByTournament(int tournamentId) async {
    final db = await getDatabase();

    final result = await db.query(
      _matchesTableName,
      where: '$_matchTournamentIdColumn = ?',
      whereArgs: [tournamentId],
      orderBy: '$_matchRoundNumberColumn ASC, $_matchIdColumn ASC',
    );

    return result.map((row) => Match.fromMap(row)).toList();
  }

  Future<List<Match>> getMatchesByRound(
    int tournamentId,
    int roundNumber,
  ) async {
    final db = await getDatabase();

    final result = await db.query(
      _matchesTableName,
      where: '$_matchTournamentIdColumn = ? AND $_matchRoundNumberColumn = ?',
      whereArgs: [tournamentId, roundNumber],
      orderBy: '$_matchIdColumn ASC',
    );

    return result.map((row) => Match.fromMap(row)).toList();
  }

  Future<int> updateMatch(Match match) async {
    if (match.id == null) {
      throw ArgumentError('Cannot update a match without an ID.');
    }

    final db = await getDatabase();

    final matchData = match.toMap()..remove('id');

    return await db.update(
      _matchesTableName,
      matchData,
      where: '$_matchIdColumn = ?',
      whereArgs: [match.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> deleteMatch(int matchId) async {
    final db = await getDatabase();

    return await db.transaction((txn) async {
      final goals = await txn.query(
        _goalsTableName,
        columns: [_goalIdColumn],
        where: '$_goalMatchIdColumn = ?',
        whereArgs: [matchId],
        limit: 1,
      );

      if (goals.isNotEmpty) {
        throw StateError('Cannot delete a match that has recorded goals.');
      }

      return await txn.delete(
        _matchesTableName,
        where: '$_matchIdColumn = ?',
        whereArgs: [matchId],
      );
    });
  }

  // Goal CRUD
  Future<void> _validateGoal(Transaction txn, Goal goal) async {
    final matches = await txn.query(
      _matchesTableName,
      columns: [_matchHomeTeamIdColumn, _matchAwayTeamIdColumn],
      where: '$_matchIdColumn = ?',
      whereArgs: [goal.matchId],
      limit: 1,
    );

    if (matches.isEmpty) {
      throw StateError('Match not found.');
    }

    final match = matches.first;
    final homeTeamId = match[_matchHomeTeamIdColumn] as int;
    final awayTeamId = match[_matchAwayTeamIdColumn] as int;

    if (goal.teamId != homeTeamId && goal.teamId != awayTeamId) {
      throw ArgumentError('The goal team is not part of this match.');
    }

    final players = await txn.query(
      _playersTableName,
      columns: [_playerTeamIdColumn],
      where: '$_playerIdColumn = ?',
      whereArgs: [goal.playerId],
      limit: 1,
    );

    if (players.isEmpty) {
      throw StateError('Player not found.');
    }

    final playerTeamId = players.first[_playerTeamIdColumn] as int;

    if (playerTeamId != goal.teamId) {
      throw ArgumentError(
        'The selected player does not belong to the goal team.',
      );
    }
  }

  Future<int> insertGoal(Goal goal) async {
    final db = await getDatabase();

    return await db.transaction((txn) async {
      await _validateGoal(txn, goal);

      final goalData = goal.toMap()..remove(_goalIdColumn);

      return await txn.insert(
        _goalsTableName,
        goalData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }

  Future<List<Goal>> getGoalsByMatch(int matchId) async {
    final db = await getDatabase();

    final result = await db.query(
      _goalsTableName,
      where: '$_goalMatchIdColumn = ?',
      whereArgs: [matchId],
      orderBy: '$_goalMinuteColumn ASC, $_goalIdColumn ASC',
    );

    return result.map((row) => Goal.fromMap(row)).toList();
  }

  Future<int> updateGoal(Goal goal) async {
    if (goal.id == null) {
      throw ArgumentError('Cannot update a goal without an ID.');
    }

    final db = await getDatabase();

    return await db.transaction((txn) async {
      await _validateGoal(txn, goal);

      final goalData = goal.toMap()..remove(_goalIdColumn);

      return await txn.update(
        _goalsTableName,
        goalData,
        where: '$_goalIdColumn = ?',
        whereArgs: [goal.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }

  Future<int> deleteGoal(int goalId) async {
    final db = await getDatabase();

    return await db.delete(
      _goalsTableName,
      where: '$_goalIdColumn = ?',
      whereArgs: [goalId],
    );
  }

  Future<int> deleteGoalsByMatch(int matchId) async {
    final db = await getDatabase();

    return await db.delete(
      _goalsTableName,
      where: '$_goalMatchIdColumn = ?',
      whereArgs: [matchId],
    );
  }
}
