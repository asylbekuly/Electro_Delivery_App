class CategoryModel {
  final String image, name;

  CategoryModel({required this.image, required this.name});
}

List<CategoryModel> myCategories = [
  CategoryModel(
    image: 'assets/food-delivery(foodel)/macbook1.png',
    name: 'Laptop',
  ),
  CategoryModel(
    image: 'food-delivery(foodel)/phone.png', 
    name: 'Phone',
  ),
  CategoryModel(
    image: 'food-delivery(foodel)/tablet.png',
    name: 'Tablet',
  ),
  CategoryModel(
    image: 'food-delivery(foodel)/watch.png',
    name: 'Watch',
  ),
];