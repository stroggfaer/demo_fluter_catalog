class Basket {
  Basket({
    required this.id,
    required this.image,
    required this.title,
  });

  final String image, title;
  final int id;

  factory Basket.fromJson(Map<String, dynamic> json) => Basket(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    image: json["image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
  };
  static empty() => Basket(id: 0, title: '', image: '');
}