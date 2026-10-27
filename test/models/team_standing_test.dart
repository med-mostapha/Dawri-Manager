import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_organizer/models/team_standing.dart';

void main() {
  group('TeamStanding', () {
    test('calculates goal difference correctly', () {
      const standing = TeamStanding(
        teamId: 1,
        teamName: 'CHENAGHITTA',
        played: 3,
        won: 2,
        drawn: 0,
        lost: 1,
        goalsFor: 6,
        goalsAgainst: 3,
        points: 6,
      );

      expect(standing.goalDifference, 3);
    });

    test('supports a negative goal difference', () {
      const standing = TeamStanding(
        teamId: 2,
        teamName: 'LEHREIGVA',
        played: 3,
        won: 0,
        drawn: 1,
        lost: 2,
        goalsFor: 2,
        goalsAgainst: 5,
        points: 1,
      );

      expect(standing.goalDifference, -3);
    });
  });
}
