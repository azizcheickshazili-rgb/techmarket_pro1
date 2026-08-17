import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the login business rule: reject obviously invalid input
/// before ever hitting the network, then delegate to the repository.
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String username,
    required String password,
  }) {
    if (username.trim().isEmpty || password.isEmpty) {
      return Future<Result<UserEntity>>.value(
        const Result<UserEntity>.err(
          AuthFailure('Le nom d\'utilisateur et le mot de passe sont requis.'),
        ),
      );
    }
    return _repository.login(username: username.trim(), password: password);
  }
}
