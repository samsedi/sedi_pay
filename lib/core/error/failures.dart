import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

/// Failure originating from a remote server (HTTP errors, timeouts, etc.).
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Failure reading from or writing to local cache/storage.
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

/// Failure due to no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}
