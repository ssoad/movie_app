// Movie Repository Implementation
// Implements the repository interface from domain layer

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';


class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({int page = 1, int limit = 20}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getMovies(page: page, limit: limit);
        await localDataSource.cacheMovies(remoteMovies);
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getCachedMovies(page: page, limit: limit);
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
  
  @override
  Future<Either<Failure, MovieEntity?>> getMovieById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovie = await remoteDataSource.getMovieById(id);
        if (remoteMovie != null) {
          await localDataSource.cacheMovie(remoteMovie);
        }
        return Right(remoteMovie);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovie = await localDataSource.getCachedMovieById(id);
        return Right(localMovie);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
