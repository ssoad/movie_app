import '../domain/favourite_repository.dart';
import 'favourite_local_service.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteLocalService localService;
  FavouriteRepositoryImpl(this.localService);

  @override
  Future<List<int>> getFavourites() => localService.getFavourites();

  @override
  Future<bool> isFavourite(int movieId) => localService.isFavourite(movieId);

  @override
  Future<void> addFavourite(int movieId) => localService.addFavourite(movieId);

  @override
  Future<void> removeFavourite(int movieId) =>
      localService.removeFavourite(movieId);

  @override
  Future<void> toggleFavourite(int movieId) =>
      localService.toggleFavourite(movieId);
}
