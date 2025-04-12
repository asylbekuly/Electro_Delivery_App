class FavoriteModel {
  final int? id;
  final String name;
  final String image;
  final double price;
  final double? rate;
  final double? distance;

  FavoriteModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rate,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'rate': rate,
      'distance': distance,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'], 
      rate: map['rate'],
      distance: map['distance'],
    );
  }
}
