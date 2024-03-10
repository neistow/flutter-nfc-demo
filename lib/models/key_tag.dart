class KeyTagModel {
  final String id;
  final String name;
  final String description;

  const KeyTagModel(
      {required this.id, required this.name, required this.description});

  Map<String, Object?> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };

  factory KeyTagModel.fromJson(Map<String, Object?> json) => KeyTagModel(
      id: json["id"] as String,
      name: json["name"] as String,
      description: json["description"] as String);
}
