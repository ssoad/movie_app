// Movie Remote Data Source
// Handles API calls and external data sources

import 'package:flutter_riverpod_clean_architecture/core/network/api_client.dart';
import 'package:flutter_riverpod_clean_architecture/core/error/exceptions.dart';
import '../models/home_model.dart';

abstract class MovieRemoteDataSource {
  /// Fetches movies data from the remote API with pagination
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<MovieModel>> getMovies({int page = 1, int limit = 20});

  /// Fetches a specific movie by ID
  Future<MovieModel?> getMovieById(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MovieModel>> getMovies({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.get(
        '/photos/',
        queryParameters: {'_limit': limit, '_page': page},
      );

      if (response != null && response is List) {
        return (response)
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(message: 'Invalid response format');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MovieModel?> getMovieById(int id) async {
    try {
      final response = await apiClient.get('/photos/$id');

      if (response != null) {
        return MovieModel.fromJson(response as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
