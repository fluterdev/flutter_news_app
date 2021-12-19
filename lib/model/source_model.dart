class SourceModel {
  final String? id;
  final String? name;

  const SourceModel({
    this.id,
    this.name,
  });

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
    );
  }
}
