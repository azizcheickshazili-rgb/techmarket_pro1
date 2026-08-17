import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  });

  Future<Result<UserEntity>> currentUser();

  Future<void> logout();

  Future<bool> hasActiveSession();
}
