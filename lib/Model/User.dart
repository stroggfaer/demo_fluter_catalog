class User {
  User({
    required this.id,
    required this.name,
  });

  final String name;
  final int id;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
  static empty() => User(id: 0, name: '');
}