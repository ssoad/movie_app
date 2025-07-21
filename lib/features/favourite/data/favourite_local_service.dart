import 'package:flutter_riverpod_clean_architecture/core/storage/local_storage_service.dart';

class FavouriteLocalService {
  static const String favouritesKey = 'favorite_movie_ids';
  final LocalStorageService localStorageService;

  FavouriteLocalService(this.localStorageService);

  Future<List<int>> getFavourites() async {
    final ids = localStorageService.getStringList(favouritesKey) ?? [];
    return ids.map(int.parse).toList();
  }

  Future<bool> isFavourite(int movieId) async {
    final ids = localStorageService.getStringList(favouritesKey) ?? [];
    return ids.contains(movieId.toString());
  }

  Future<void> addFavourite(int movieId) async {
    final ids = localStorageService.getStringList(favouritesKey) ?? [];
    if (!ids.contains(movieId.toString())) {
      ids.add(movieId.toString());
      await localStorageService.setStringList(favouritesKey, ids);
    }
  }

  Future<void> removeFavourite(int movieId) async {
    final ids = localStorageService.getStringList(favouritesKey) ?? [];
    ids.remove(movieId.toString());
    await localStorageService.setStringList(favouritesKey, ids);
  }

  Future<void> toggleFavourite(int movieId) async {
    final ids = localStorageService.getStringList(favouritesKey) ?? [];
    if (ids.contains(movieId.toString())) {
      ids.remove(movieId.toString());
    } else {
      ids.add(movieId.toString());
    }
    await localStorageService.setStringList(favouritesKey, ids);
  }
}
