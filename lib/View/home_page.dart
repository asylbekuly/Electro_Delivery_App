import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/Model/category_model.dart';
import 'package:food_delivery_app/Model/product_model.dart';
import 'package:food_delivery_app/Provider/cart_provider.dart';
import 'package:food_delivery_app/Provider/theme_provider.dart';
import 'package:food_delivery_app/View/cart.dart';
import 'package:food_delivery_app/Widgets/food_product_items.dart';
import 'package:food_delivery_app/consts.dart';
import 'package:food_delivery_app/Provider/firebase_service.dart';
import 'package:food_delivery_app/View/favorites_page.dart';
import 'package:food_delivery_app/Provider/favorite_provider.dart';
import 'package:food_delivery_app/View/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category = "Phone";
  List<MyProductModel> allProducts = [];
  List<MyProductModel> productModel = [];
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Функция для загрузки данных из Firestore
  void _loadData() async {
    FirebaseService firebaseService = FirebaseService();

    // Получаем продукты из Firestore
    final products = await firebaseService.getProducts();
    final categoryList = await firebaseService.getCategories();

    setState(() {
      allProducts = products; // Все продукты
      categories = categoryList;

      // Применяем фильтрацию для категории по умолчанию
      filterProductByCategory(category);
    });
  }

  // Фильтрация продуктов по выбранной категории
  void filterProductByCategory(String selectedCategory) {
    setState(() {
      category = selectedCategory;
      // Фильтруем продукты по категории
      productModel =
          allProducts
              .where(
                (element) =>
                    element.category.toLowerCase() ==
                    selectedCategory.toLowerCase(),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧭 Location & Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Location",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: korange,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Astana, Kazakhstan",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) {
                                return SearchModal(allProducts: allProducts);
                              },
                            );
                          },
                          child: _iconButton(Icons.search, context),
                        ),

                        const SizedBox(width: 6),

                        Consumer<FavoriteProvider>(
                          builder: (context, favProvider, _) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const FavoritesPage(),
                                      ),
                                    );
                                  },
                                  child: _iconButton(
                                    Icons.favorite_border,
                                    context,
                                  ),
                                ),
                                if (favProvider.favorites.isNotEmpty)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        favProvider.favorites.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(width: 6),

                        // 🛒 Корзина
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Cart()),
                            );
                          },
                          child: Stack(
                            children: [
                              _iconButton(
                                Icons.shopping_cart_outlined,
                                context,
                              ),
                              if (cartProvider.carts.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      cartProvider.carts.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        // 🌙 Переключатель темы
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Заголовок
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Let's find the best electronics around you",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Категории
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Find by Category",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text("See All", style: TextStyle(color: korange)),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Список категорий
              SizedBox(
                height: 120,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    final isSelected = category == item.name;
                    return GestureDetector(
                      onTap: () => filterProductByCategory(item.name),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              isSelected
                                  ? Border.all(color: korange, width: 2)
                                  : Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(item.image, width: 60),
                            const SizedBox(height: 10),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Result (${productModel.length})",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: productModel.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    return FoodProductItems(productModel: productModel[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Icon(icon, color: Theme.of(context).iconTheme.color),
    );
  }
}

class SearchModal extends StatefulWidget {
  final List<MyProductModel> allProducts;

  const SearchModal({super.key, required this.allProducts});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  late List<MyProductModel> filteredProducts;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.allProducts;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts =
          widget.allProducts
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Поле поиска
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: updateSearch,
            ),
            const SizedBox(height: 20),

            // Список результатов
            Expanded(
              child:
                  filteredProducts.isEmpty
                      ? const Center(child: Text("No products found"))
                      : ListView.separated(
                        itemCount: filteredProducts.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              ),
                            ),

                            title: Text(product.name),
                            subtitle: Text("\$${product.price.toString()}"),
                            onTap: () {
                              Navigator.pop(context); // Закрыть поиск
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ProductDetailPage(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
