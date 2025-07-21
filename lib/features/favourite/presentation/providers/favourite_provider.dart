import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/core/providers/storage_providers.dart';
import '../../data/favourite_local_service.dart';
import '../../data/favourite_repository_impl.dart';
import '../../domain/favourite_repository.dart';

final favouriteRepositoryProvider = Provider<FavouriteRepository>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return FavouriteRepositoryImpl(FavouriteLocalService(localStorage));
});

class FavouriteNotifier extends StateNotifier<Set<int>> {
  final FavouriteRepository repository;
  FavouriteNotifier(this.repository) : super({}) {
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await repository.getFavourites();
    state = Set.from(favs);
  }

  Future<void> toggleFavourite(int movieId) async {
    await repository.toggleFavourite(movieId);
    await _loadFavourites();
  }

  bool isFavourite(int movieId) => state.contains(movieId);
}

final favouriteNotifierProvider =
    StateNotifierProvider<FavouriteNotifier, Set<int>>((ref) {
      final repo = ref.watch(favouriteRepositoryProvider);
      return FavouriteNotifier(repo);
    });
