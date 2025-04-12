import 'package:flutter/foundation.dart';
import '../Model/favorite_model.dart';
import '../Services/favorite_service.dart';
import '../Services/favorite_service_sqlite.dart';
import '../Services/favorite_service_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service =
      kIsWeb ? FavoriteServiceWeb() : FavoriteServiceSQLite();

  List<FavoriteModel> _favorites = [];

  List<FavoriteModel> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _service.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteModel item) async {
    await _service.addFavorite(item);
    await loadFavorites();
  }

  Future<void> removeFavorite(int id) async {
    await _service.deleteFavorite(id);
    await loadFavorites();
  }

  Future<void> clearFavorites() async {
    for (final item in _favorites) {
      await _service.deleteFavorite(item.id ?? item.name.hashCode);
    }
    await loadFavorites();
  }
}
