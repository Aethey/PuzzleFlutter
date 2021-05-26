class PuzzleMockModel {
  final int id;

  final String name;

  PuzzleMockModel(this.id, this.name);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }
}
