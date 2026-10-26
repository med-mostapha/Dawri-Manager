enum MatchStatus { scheduled, finished }

class Match {
  final int? id;
  final int tournamentId;
  final int homeTeamId;
  final int awayTeamId;
  final int roundNumber;
  final DateTime? scheduledAt;
  final MatchStatus status;

  const Match({
    this.id,
    required this.tournamentId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.roundNumber,
    this.scheduledAt,
    this.status = MatchStatus.scheduled,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'home_team_id': homeTeamId,
      'away_team_id': awayTeamId,
      'round_number': roundNumber,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'status': status.name,
    };
  }

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'] as int?,
      tournamentId: map['tournament_id'] as int,
      homeTeamId: map['home_team_id'] as int,
      awayTeamId: map['away_team_id'] as int,
      roundNumber: map['round_number'] as int,
      scheduledAt: map['scheduled_at'] == null
          ? null
          : DateTime.parse(map['scheduled_at'] as String),
      status: MatchStatus.values.byName(map['status'] as String),
    );
  }

  Match copyWith({
    int? id,
    int? tournamentId,
    int? homeTeamId,
    int? awayTeamId,
    int? roundNumber,
    DateTime? scheduledAt,
    bool clearScheduledAt = false,
    MatchStatus? status,
  }) {
    return Match(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      roundNumber: roundNumber ?? this.roundNumber,
      scheduledAt: clearScheduledAt ? null : scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
    );
  }
}
