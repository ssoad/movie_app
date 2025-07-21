// Movie Providers
// Riverpod providers for the home feature

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/core/usecases/usecase.dart';

import '../../../../core/providers/network_providers.dart';
import '../../../../core/providers/storage_providers.dart';
import '../data/datasources/home_local_datasource.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/entities/home_entity.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_all_homes.dart';
import '../domain/usecases/get_home_by_id.dart';

// Data sources
final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>(
  (ref) => MovieRemoteDataSourceImpl(
    apiClient: ref.read(apiClientProvider),
  ),
);

final movieLocalDataSourceProvider = Provider<MovieLocalDataSource>(
  (ref) => MovieLocalDataSourceImpl(
    localStorageService: ref.read(localStorageServiceProvider),
  ),
);

// Repository
final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepositoryImpl(
    remoteDataSource: ref.read(movieRemoteDataSourceProvider),
    localDataSource: ref.read(movieLocalDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

// Use cases
final getMoviesProvider = Provider<GetMovies>(
  (ref) => GetMovies(ref.read(movieRepositoryProvider)),
);

final getMovieByIdProvider = Provider<GetMovieById>(
  (ref) => GetMovieById(ref.read(movieRepositoryProvider)),
);

// Pagination state
final currentPageProvider = StateProvider<int>((ref) => 1);
final moviesPerPageProvider = StateProvider<int>((ref) => 20);
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

// Movies list with pagination
final moviesListProvider = StateNotifierProvider<MoviesNotifier, AsyncValue<List<MovieEntity>>>(
  (ref) => MoviesNotifier(ref),
);

class MoviesNotifier extends StateNotifier<AsyncValue<List<MovieEntity>>> {
  final Ref ref;
  List<MovieEntity> _allMovies = [];
  bool _hasMore = true;

  MoviesNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadMovies();
  }

  Future<void> loadMovies({bool refresh = false}) async {
    if (refresh) {
      _allMovies = [];
      _hasMore = true;
      ref.read(currentPageProvider.notifier).state = 1;
      state = const AsyncValue.loading();
    }

    if (!_hasMore) return;

    try {
      final usecase = ref.read(getMoviesProvider);
      final page = ref.read(currentPageProvider);
      final limit = ref.read(moviesPerPageProvider);
      
      final result = await usecase(MoviesParams(page: page, limit: limit));
      
      result.fold(
        (failure) {
          state = AsyncValue.error(failure.toString(), StackTrace.current);
        },
        (newMovies) {
          if (newMovies.isEmpty) {
            _hasMore = false;
          } else {
            _allMovies.addAll(newMovies);
            ref.read(currentPageProvider.notifier).state = page + 1;
          }
          state = AsyncValue.data(_allMovies);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;
    
    ref.read(isLoadingMoreProvider.notifier).state = true;
    await loadMovies();
    ref.read(isLoadingMoreProvider.notifier).state = false;
  }

  Future<void> refresh() async {
    await loadMovies(refresh: true);
  }
}

// Selected movie providers
final selectedMovieIdProvider = StateProvider<int?>((ref) => null);

final selectedMovieProvider = FutureProvider<MovieEntity?>((ref) async {
  final id = ref.watch(selectedMovieIdProvider);
  if (id == null) return null;
  
  final usecase = ref.read(getMovieByIdProvider);
  final result = await usecase(MovieParams(id: id));
  
  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (movie) => movie,
  );
});
