// Movie Local Data Source
// Handles local storage operations (SharedPreferences, SQLite, etc.)

import 'package:flutter_riverpod_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_riverpod_clean_architecture/core/storage/local_storage_service.dart';
import '../models/home_model.dart';

abstract class MovieLocalDataSource {
  /// Gets cached movies data with pagination
  ///
  /// Throws a [CacheException] if no cached data is present
  Future<List<MovieModel>> getCachedMovies({int page = 1, int limit = 20});
  
  /// Gets a cached movie by ID
  Future<MovieModel?> getCachedMovieById(int id);
  
  /// Caches movies data
  Future<void> cacheMovies(List<MovieModel> movies);
  
  /// Caches a single movie
  Future<void> cacheMovie(MovieModel movie);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final LocalStorageService localStorageService;
  static const String moviesKey = 'cached_movies';
  
  MovieLocalDataSourceImpl({required this.localStorageService});
  
  @override
  Future<List<MovieModel>> getCachedMovies({int page = 1, int limit = 20}) async {
    try {
      final cachedData = await localStorageService.getObject(moviesKey);
      if (cachedData != null && cachedData is List) {
        final allMovies = cachedData
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Apply pagination to cached data
        final start = (page - 1) * limit;
        final end = start + limit;
        
        if (start >= allMovies.length) return [];
        
        return allMovies.sublist(
          start,
          end > allMovies.length ? allMovies.length : end,
        );
      }
      throw CacheException(message: 'No cached movies found');
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
  
  @override
  Future<MovieModel?> getCachedMovieById(int id) async {
    try {
      final cachedData = await localStorageService.getObject(moviesKey);
      if (cachedData != null && cachedData is List) {
        final allMovies = cachedData
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        try {
          return allMovies.firstWhere((movie) => movie.id == id);
        } catch (e) {
          return null; // Movie not found in cache
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> cacheMovies(List<MovieModel> movies) async {
    try {
      // Get existing cached movies
      List<MovieModel> existingMovies = [];
      try {
        existingMovies = await getCachedMovies(page: 1, limit: 10000); // Get all cached
      } catch (e) {
        // No existing cache, start fresh
      }
      
      // Merge new movies with existing ones (avoid duplicates)
      final Map<int, MovieModel> movieMap = {
        for (var movie in existingMovies) movie.id: movie,
      };
      
      for (var movie in movies) {
        movieMap[movie.id] = movie;
      }
      
      final allMovies = movieMap.values.toList();
      final jsonData = allMovies.map((movie) => movie.toJson()).toList();
      
      await localStorageService.setObject(moviesKey, jsonData);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
  
  @override
  Future<void> cacheMovie(MovieModel movie) async {
    await cacheMovies([movie]);
  }
}
