class TopScorer {
  final int playerId;
  final String playerName;
  final int teamId;
  final String teamName;
  final int goals;

  const TopScorer({
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.teamName,
    required this.goals,
  });
}
