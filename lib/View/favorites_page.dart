import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Model/favorite_model.dart';
import '../Services/favorite_service.dart';
import '../Services/favorite_service_sqlite.dart';
import '../Services/favorite_service_web.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<FavoriteModel> favorites = [];
  late final FavoriteService favoriteService;

  @override
  void initState() {
    super.initState();
    favoriteService = kIsWeb ? FavoriteServiceWeb() : FavoriteServiceSQLite();
    loadFavorites();
  }

  void loadFavorites() async {
    favorites = await favoriteService.getFavorites();
    setState(() {});
  }

  void deleteFavorite(int id) async {
    await favoriteService.deleteFavorite(id);
    loadFavorites();
  }

  void clearAllFavorites() async {
    for (final fav in favorites) {
      final id = kIsWeb ? fav.name.hashCode : (fav.id ?? 0);
      await favoriteService.deleteFavorite(id);
    }
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
        centerTitle: true,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: clearAllFavorites,
            )
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "Нет избранных товаров",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                final itemId = kIsWeb ? item.name.hashCode : (item.id ?? 0);
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить из избранного'),
                        content: const Text(
                          'Вы уверены, что хотите удалить этот товар?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteFavorite(itemId);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Удалить',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.asset(
                            item.image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "\$${item.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: textColor?.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => deleteFavorite(itemId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
