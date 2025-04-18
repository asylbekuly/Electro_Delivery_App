class MyProductModel {
  final String id;
  final String image;
  final String name;
  final String category;
  final String description;
  final double price;
  final double rate;
  final double distance;

  MyProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rate,
    required this.distance,
  });


  factory MyProductModel.fromMap(Map<String, dynamic> map, String id) {
    return MyProductModel(
      id: id,
      image: map['image'] ?? '', 
      name: map['name'] ?? '', 
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      price:
          (map['price'] is String)
              ? double.tryParse(map['price']) ?? 0.0
              : map['price'] ?? 0.0, 
      rate:
          (map['rate'] is String)
              ? double.tryParse(map['rate']) ?? 0.0
              : map['rate'] ?? 0.0, 
      distance:
          (map['distance'] is String)
              ? double.tryParse(map['distance']) ?? 0.0
              : map['distance'] ?? 0.0, 
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'rate': rate,
      'distance': distance,
    };
  }
}
