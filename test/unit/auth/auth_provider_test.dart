import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket/core/utils/result.dart';
import 'package:techmarket/features/auth/domain/entities/user_entity.dart';
import 'package:techmarket/features/auth/domain/repositories/auth_repository.dart';
import 'package:techmarket/features/auth/domain/usecases/login_usecase.dart';
import 'package:techmarket/features/auth/domain/usecases/logout_usecase.dart';
import 'package:techmarket/features/auth/presentation/providers/auth_provider.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late AuthController controller;

  const UserEntity fakeUser = UserEntity(
    id: 1,
    username: 'emilys',
    email: 'emily@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
  );

  setUp(() {
    repository = _MockAuthRepository();
    controller = AuthController(
      loginUseCase: LoginUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
      repository: repository,
    );
  });

  test('initial state is AuthInitial', () {
    expect(controller.state, isA<AuthInitial>());
  });

  test('login() sets AuthAuthenticated on success and returns true', () async {
    when(() => repository.login(username: 'emilys', password: 'emilyspass'))
        .thenAnswer((_) async => const Result<UserEntity>.ok(fakeUser));

    final bool success = await controller.login(username: 'emilys', password: 'emilyspass');

    expect(success, isTrue);
    expect(controller.state, isA<AuthAuthenticated>());
    expect((controller.state as AuthAuthenticated).user, fakeUser);
  });

  test('login() sets AuthUnauthenticated with error message on failure and returns false', () async {
    when(() => repository.login(username: 'emilys', password: 'wrong'))
        .thenAnswer((_) async => const Result<UserEntity>.err(AuthFailure('bad creds')));

    final bool success = await controller.login(username: 'emilys', password: 'wrong');

    expect(success, isFalse);
    expect(controller.state, isA<AuthUnauthenticated>());
    expect((controller.state as AuthUnauthenticated).errorMessage, 'bad creds');
  });

  test('logout() calls the use case and resets state to AuthUnauthenticated', () async {
    when(() => repository.logout()).thenAnswer((_) async {});

    await controller.logout();

    expect(controller.state, isA<AuthUnauthenticated>());
    verify(() => repository.logout()).called(1);
  });

  test('restoreSession() sets AuthUnauthenticated when there is no saved session', () async {
    when(() => repository.hasActiveSession()).thenAnswer((_) async => false);

    await controller.restoreSession();

    expect(controller.state, isA<AuthUnauthenticated>());
  });

  test('restoreSession() sets AuthAuthenticated when a session is valid', () async {
    when(() => repository.hasActiveSession()).thenAnswer((_) async => true);
    when(() => repository.currentUser())
        .thenAnswer((_) async => const Result<UserEntity>.ok(fakeUser));

    await controller.restoreSession();

    expect(controller.state, isA<AuthAuthenticated>());
  });
}
