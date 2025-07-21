// Movie Repository Interface
// Define contract for data operations

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_entity.dart';

abstract class MovieRepository {
  /// Gets movies with pagination
  ///
  /// Returns [Failure] or [List<MovieEntity>]
  Future<Either<Failure, List<MovieEntity>>> getMovies({int page = 1, int limit = 20});
  
  /// Gets a specific movie entity by ID
  ///
  /// Returns [Failure] or [MovieEntity]
  Future<Either<Failure, MovieEntity?>> getMovieById(int id);
}
