class Goal {
  final int? id;
  final int matchId;
  final int playerId;
  final int teamId;
  final int? minute;

  const Goal({
    this.id,
    required this.matchId,
    required this.playerId,
    required this.teamId,
    this.minute,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_id': matchId,
      'player_id': playerId,
      'team_id': teamId,
      'minute': minute,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as int?,
      matchId: map['match_id'] as int,
      playerId: map['player_id'] as int,
      teamId: map['team_id'] as int,
      minute: map['minute'] as int?,
    );
  }

  Goal copyWith({
    int? id,
    int? matchId,
    int? playerId,
    int? teamId,
    int? minute,
    bool clearMinute = false,
  }) {
    return Goal(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      playerId: playerId ?? this.playerId,
      teamId: teamId ?? this.teamId,
      minute: clearMinute ? null : minute ?? this.minute,
    );
  }
}
