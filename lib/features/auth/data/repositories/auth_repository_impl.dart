import 'package:dio/dio.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  @override
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final UserModel user = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      if (user.accessToken != null) {
        await _secureStorage.saveTokens(
          accessToken: user.accessToken!,
          refreshToken: user.refreshToken ?? '',
        );
      }
      return Result<UserEntity>.ok(user.toEntity());
    } on DioException catch (error) {
      return Result<UserEntity>.err(_mapDioError(error));
    } catch (_) {
      return const Result<UserEntity>.err(UnknownFailure());
    }
  }

  @override
  Future<Result<UserEntity>> currentUser() async {
    try {
      final UserModel user = await _remoteDataSource.fetchCurrentUser();
      return Result<UserEntity>.ok(user.toEntity());
    } on DioException catch (error) {
      return Result<UserEntity>.err(_mapDioError(error));
    } catch (_) {
      return const Result<UserEntity>.err(UnknownFailure());
    }
  }

  @override
  Future<void> logout() => _secureStorage.clear();

  @override
  Future<bool> hasActiveSession() => _secureStorage.hasValidSession();

  Failure _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkFailure();
    }
    final int? status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return const AuthFailure();
    }
    return ServerFailure(
      error.message ?? 'Erreur serveur.',
      statusCode: status,
    );
  }
}
