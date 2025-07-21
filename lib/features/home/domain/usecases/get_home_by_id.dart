// Get Movie By ID Use Case
// Business logic for retrieving a specific movie entity

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetMovieById implements UseCase<MovieEntity?, MovieParams> {
  final MovieRepository repository;
  
  GetMovieById(this.repository);
  
  @override
  Future<Either<Failure, MovieEntity?>> call(MovieParams params) {
    return repository.getMovieById(params.id);
  }
}

class MovieParams extends Equatable {
  final int id;
  
  const MovieParams({required this.id});
  
  @override
  List<Object> get props => [id];
}
