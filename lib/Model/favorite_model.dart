class FavoriteModel {
  final int? id;
  final String name;
  final String image;
  final double price;

  FavoriteModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
    );
  }
}
