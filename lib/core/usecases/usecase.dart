// Use Case Base Classes
// Base classes for implementing use cases following Clean Architecture

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Abstract base class for all use cases
/// 
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case parameters for operations that don't require any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}