abstract class FavouriteRepository {
  Future<List<int>> getFavourites();
  Future<bool> isFavourite(int movieId);
  Future<void> addFavourite(int movieId);
  Future<void> removeFavourite(int movieId);
  Future<void> toggleFavourite(int movieId);
}
