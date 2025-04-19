import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:animate_do/animate_do.dart';

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
        title: const Text("Favourites"),
        centerTitle: true,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: clearAllFavorites,
            ),
        ],
      ),
      body:
          favorites.isEmpty
              ? const Center(
                child: Text(
                  "No favorites yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  final itemId = kIsWeb ? item.name.hashCode : (item.id ?? 0);
                  return FadeInUp(
                    delay: Duration(milliseconds: (index + 1) * 200),
                    child: GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Favorite'),
                                content: const Text(
                                  'Aere you sure you want to delete this favorite?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteFavorite(itemId);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Remove',
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
                            ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${item.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: textColor?.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.rate?.toStringAsFixed(1) ??
                                              "0.0",
                                          style: TextStyle(
                                            color: textColor?.withOpacity(0.8),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.pink,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${item.distance?.toStringAsFixed(0) ?? "0"}m",
                                          style: TextStyle(
                                            color: textColor?.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => deleteFavorite(itemId),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
