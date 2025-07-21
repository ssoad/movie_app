// Get Movies Use Case
// Business logic for retrieving movies with pagination

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetMovies implements UseCase<List<MovieEntity>, MoviesParams> {
  final MovieRepository repository;
  
  GetMovies(this.repository);
  
  @override
  Future<Either<Failure, List<MovieEntity>>> call(MoviesParams params) {
    return repository.getMovies(page: params.page, limit: params.limit);
  }
}

class MoviesParams {
  final int page;
  final int limit;
  
  const MoviesParams({
    required this.page,
    required this.limit,
  });
}
