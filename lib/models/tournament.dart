class Tournament {
  final int? id;
  final String name;
  final String createdAt;
  final MatchType matchType;

  Tournament({
    this.id,
    required this.name,
    required this.createdAt,
    this.matchType = MatchType.homeAndAway,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'match_type': matchType.name,
    };
  }

  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: map['created_at'] as String,
      matchType: MatchType.values.byName(
        map['match_type'] as String? ?? 'homeAndAway',
      ),
    );
  }
}

enum MatchType {
  singleRound, // Aller simple
  homeAndAway, // Aller-retour
}
