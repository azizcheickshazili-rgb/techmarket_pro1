import 'package:equatable/equatable.dart';

/// Base type for domain-level failures. Kept deliberately small and
/// serialisable-free — repositories translate transport/storage errors
/// into one of these before they ever reach the presentation layer.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pas de connexion internet.']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Identifiants invalides.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de stockage local.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Une erreur inattendue est survenue.']);
}

/// A minimal, dependency-free Either replacement: a call either
/// [Result.ok]s with a value or [Result.err]s with a [Failure].
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(Failure failure) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  R when<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) {
    final Result<T> self = this;
    if (self is Ok<T>) return ok(self.value);
    if (self is Err<T>) return err(self.failure);
    throw StateError('Unreachable');
  }
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
