class Team {
  final int? id;
  final int tournamentId;
  final String name;

  Team({this.id, required this.tournamentId, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'tournament_id': tournamentId, 'name': name};
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as int?,
      tournamentId: map['tournament_id'] as int,
      name: map['name'] as String,
    );
  }
}
