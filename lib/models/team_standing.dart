class TeamStanding {
  final int teamId;
  final String teamName;

  final int played;
  final int won;
  final int drawn;
  final int lost;

  final int goalsFor;
  final int goalsAgainst;

  int get goalDifference => goalsFor - goalsAgainst;

  final int points;

  const TeamStanding({
    required this.teamId,
    required this.teamName,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });
}
