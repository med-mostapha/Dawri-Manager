import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/tournament.dart';

class ScheduleGenerator {
  static List<Match> generate({
    required int tournamentId,
    required List<int> teamIds,
    required MatchType matchType,
  }) {
    if (teamIds.length < 2) {
      throw ArgumentError('At least two teams are required.');
    }

    if (teamIds.toSet().length != teamIds.length) {
      throw ArgumentError('Team IDs must be unique.');
    }

    final teams = List<int>.from(teamIds);
    final hasOddTeams = teams.length.isOdd;

    if (hasOddTeams) {
      teams.add(-1);
    }

    final teamCount = teams.length;
    final roundsPerLeg = teamCount - 1;
    final matchesPerRound = teamCount ~/ 2;

    final firstLeg = <Match>[];
    final rotation = List<int>.from(teams);

    for (int round = 0; round < roundsPerLeg; round++) {
      for (int i = 0; i < matchesPerRound; i++) {
        final first = rotation[i];
        final second = rotation[teamCount - 1 - i];

        if (first == -1 || second == -1) {
          continue;
        }

        final homeTeamId = round.isEven ? first : second;
        final awayTeamId = round.isEven ? second : first;

        firstLeg.add(
          Match(
            tournamentId: tournamentId,
            homeTeamId: homeTeamId,
            awayTeamId: awayTeamId,
            roundNumber: round + 1,
          ),
        );
      }

      final lastTeam = rotation.removeLast();
      rotation.insert(1, lastTeam);
    }

    if (matchType == MatchType.singleRound) {
      return firstLeg;
    }

    final secondLeg = firstLeg.map((match) {
      return Match(
        tournamentId: tournamentId,
        homeTeamId: match.awayTeamId,
        awayTeamId: match.homeTeamId,
        roundNumber: match.roundNumber + roundsPerLeg,
      );
    }).toList();

    return [...firstLeg, ...secondLeg];
  }
}
