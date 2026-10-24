import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';

void main() {
  group('Models tests', () {
    test('Create objects and check their relations', () {
      final tournament = Tournament(
        id: 1,
        name: 'Ramadan Cup',
        createdAt: '2026-10-22',
      );

      final team = Team(id: 10, tournamentId: tournament.id!, name: 'Al Amal');

      final player = Player(
        id: 100,
        teamId: team.id!,
        name: 'Mohamed',
        age: 17,
      );

      expect(team.tournamentId, tournament.id);
      expect(player.teamId, team.id);
      expect(player.age, 17);
    });

    test('Convert Tournament to Map and back', () {
      final original = Tournament(
        id: 1,
        name: 'Ramadan Cup',
        createdAt: '2026-10-22',
      );

      final map = original.toMap();
      final restored = Tournament.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.createdAt, original.createdAt);
    });

    test('Convert Team to Map and back', () {
      final original = Team(id: 10, tournamentId: 1, name: 'Al Amal');

      final restored = Team.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.tournamentId, original.tournamentId);
      expect(restored.name, original.name);
    });

    test('Convert Player to Map and back', () {
      final original = Player(id: 100, teamId: 10, name: 'Mohamed', age: 7);

      final restored = Player.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.teamId, original.teamId);
      expect(restored.name, original.name);
      expect(restored.age, original.age);
    });

    test('Player age can be null', () {
      final player = Player(teamId: 10, name: 'Ahmed');

      final restored = Player.fromMap(player.toMap());

      expect(restored.age, isNull);
    });
  });
}
