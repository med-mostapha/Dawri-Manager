import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/schedule_generator.dart';

void main() {
  group('ScheduleGenerator', () {
    const tournamentId = 1;
    final teamIds = [10, 20, 30, 40];

    test('generates 6 matches for 4 teams in single round', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: teamIds,
        matchType: MatchType.singleRound,
      );

      expect(matches.length, 6);
    });

    test('generates 12 matches for 4 teams in home and away', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: teamIds,
        matchType: MatchType.homeAndAway,
      );

      expect(matches.length, 12);
    });

    test('generates 3 matches for 3 teams in single round', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: [10, 20, 30],
        matchType: MatchType.singleRound,
      );

      expect(matches.length, 3);
    });

    test('each team plays at most once per round', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: teamIds,
        matchType: MatchType.homeAndAway,
      );

      final roundNumbers = matches.map((match) => match.roundNumber).toSet();

      for (final roundNumber in roundNumbers) {
        final roundMatches = matches.where(
          (match) => match.roundNumber == roundNumber,
        );

        final playingTeams = <int>{};

        for (final match in roundMatches) {
          expect(playingTeams.add(match.homeTeamId), isTrue);
          expect(playingTeams.add(match.awayTeamId), isTrue);
        }
      }
    });

    test('return leg reverses home and away teams', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: teamIds,
        matchType: MatchType.homeAndAway,
      );

      final firstLeg = matches
          .where((match) => match.roundNumber <= 3)
          .toList();

      final secondLeg = matches
          .where((match) => match.roundNumber > 3)
          .toList();

      expect(firstLeg.length, 6);
      expect(secondLeg.length, 6);

      for (final firstMatch in firstLeg) {
        final returnMatch = secondLeg.where(
          (match) =>
              match.homeTeamId == firstMatch.awayTeamId &&
              match.awayTeamId == firstMatch.homeTeamId,
        );

        expect(returnMatch.length, 1);
      }
    });

    test('throws when fewer than 2 teams are provided', () {
      expect(
        () => ScheduleGenerator.generate(
          tournamentId: tournamentId,
          teamIds: [10],
          matchType: MatchType.singleRound,
        ),
        throwsArgumentError,
      );
    });

    test('throws when team IDs are duplicated', () {
      expect(
        () => ScheduleGenerator.generate(
          tournamentId: tournamentId,
          teamIds: [10, 20, 20],
          matchType: MatchType.singleRound,
        ),
        throwsArgumentError,
      );
    });

    test('all matches belong to the requested tournament', () {
      final matches = ScheduleGenerator.generate(
        tournamentId: tournamentId,
        teamIds: teamIds,
        matchType: MatchType.homeAndAway,
      );

      expect(
        matches.every((match) => match.tournamentId == tournamentId),
        isTrue,
      );
    });
  });
}
