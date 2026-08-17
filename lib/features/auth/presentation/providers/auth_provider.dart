import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

final Provider<AuthRemoteDataSource> authRemoteDataSourceProvider =
    Provider<AuthRemoteDataSource>(
  (Ref ref) => AuthRemoteDataSourceImpl(ref.watch(apiClientProvider).dio),
);

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (Ref ref) => AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

final Provider<LoginUseCase> loginUseCaseProvider = Provider<LoginUseCase>(
  (Ref ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final Provider<LogoutUseCase> logoutUseCaseProvider = Provider<LogoutUseCase>(
  (Ref ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

/// Immutable state describing the authentication lifecycle of the app.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserEntity user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.errorMessage});
  final String? errorMessage;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _repository = repository,
        super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _repository;

  Future<void> restoreSession() async {
    state = const AuthLoading();
    final bool hasSession = await _repository.hasActiveSession();
    if (!hasSession) {
      state = const AuthUnauthenticated();
      return;
    }
    final Result<UserEntity> result = await _repository.currentUser();
    state = result.when(
      ok: (UserEntity user) => AuthAuthenticated(user),
      err: (_) => const AuthUnauthenticated(),
    );
  }

  Future<bool> login({required String username, required String password}) async {
    state = const AuthLoading();
    final Result<UserEntity> result =
        await _loginUseCase(username: username, password: password);
    return result.when(
      ok: (UserEntity user) {
        state = AuthAuthenticated(user);
        return true;
      },
      err: (Failure failure) {
        state = AuthUnauthenticated(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = const AuthUnauthenticated();
  }
}

final StateNotifierProvider<AuthController, AuthState> authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((Ref ref) {
  return AuthController(
    loginUseCase: ref.watch(loginUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});
