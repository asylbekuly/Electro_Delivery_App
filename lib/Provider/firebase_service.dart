import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/Model/product_model.dart';
import 'package:food_delivery_app/Model/category_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получение продуктов
  Future<List<MyProductModel>> getProducts() async {
    QuerySnapshot snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) {
      return MyProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Получение категорий
  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) {
      return CategoryModel(
        image: doc['image'],
        name: doc['name'],
      );
    }).toList();
  }
}
