class Player {
  final int? id;
  final int teamId;
  final String name;
  final int? age;

  Player({this.id, required this.teamId, required this.name, this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'team_id': teamId, 'name': name, 'age': age};
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int?,
      teamId: map['team_id'] as int,
      name: map['name'] as String,
      age: map['age'] as int?,
    );
  }
}
