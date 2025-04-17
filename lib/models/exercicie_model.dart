class Exercicie {
  final int? id;
  final String name;
  final String description;
  final int repetition;

  Exercicie({
    this.id,
    required this.name,
    required this.description,
    required this.repetition,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'description': description,
      'repetition': repetition,
    };
    if (id != null) {
      map['id'] = id as int;
    }
    return map;
  }

  factory Exercicie.fromMap(Map<String, dynamic> map) {
    return Exercicie(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      repetition: map['repetition'],
    );
  }
}
