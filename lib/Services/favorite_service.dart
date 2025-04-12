import '../Model/favorite_model.dart';

abstract class FavoriteService {
  Future<void> addFavorite(FavoriteModel favorite);
  Future<List<FavoriteModel>> getFavorites();
  Future<void> deleteFavorite(int id);
}
