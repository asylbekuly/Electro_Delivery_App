import '../Model/favorite_model.dart';
import 'favorite_service.dart';

class FavoriteServiceWeb implements FavoriteService {
  static final List<FavoriteModel> _favorites = [];

  @override
  Future<void> addFavorite(FavoriteModel favorite) async {
    if (!_favorites.any((f) => f.name == favorite.name)) {
      _favorites.add(favorite);
    }
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    return _favorites;
  }

  @override
  Future<void> deleteFavorite(int id) async {
    _favorites.removeWhere((f) => f.name.hashCode == id);
  }
}
