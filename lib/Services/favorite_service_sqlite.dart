import '../Model/favorite_model.dart';
import '../Database/favorite_db.dart';
import 'favorite_service.dart';

class FavoriteServiceSQLite implements FavoriteService {
  @override
  Future<void> addFavorite(FavoriteModel favorite) async {
    await FavoriteDB().addFavorite(favorite);
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    return await FavoriteDB().getFavorites();
  }

  @override
  Future<void> deleteFavorite(int id) async {
    await FavoriteDB().deleteFavorite(id);
  }
}
