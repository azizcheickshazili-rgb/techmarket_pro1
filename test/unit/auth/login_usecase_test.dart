import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket_pro1/core/utils/result.dart';
import 'package:techmarket_pro1/features/auth/domain/entities/user_entity.dart';
import 'package:techmarket_pro1/features/auth/domain/repositories/auth_repository.dart';
import 'package:techmarket_pro1/features/auth/domain/usecases/login_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late LoginUseCase useCase;

  const UserEntity fakeUser = UserEntity(
    id: 1,
    username: 'emilys',
    email: 'emily@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
  );

  setUp(() {
    repository = _MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('returns AuthFailure without calling the repository when username is blank', () async {
      final Result<UserEntity> result = await useCase(username: '  ', password: 'pass');

      expect(result.isErr, isTrue);
      verifyNever(() => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ));
    });

    test('returns AuthFailure without calling the repository when password is empty', () async {
      final Result<UserEntity> result = await useCase(username: 'emilys', password: '');

      expect(result.isErr, isTrue);
      verifyNever(() => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ));
    });

    test('delegates to repository.login with trimmed username on valid input', () async {
      when(() => repository.login(username: 'emilys', password: 'emilyspass'))
          .thenAnswer((_) async => const Result<UserEntity>.ok(fakeUser));

      final Result<UserEntity> result =
          await useCase(username: '  emilys  ', password: 'emilyspass');

      expect(result.isOk, isTrue);
      result.when(
        ok: (UserEntity user) => expect(user, fakeUser),
        err: (_) => fail('expected Ok'),
      );
      verify(() => repository.login(username: 'emilys', password: 'emilyspass')).called(1);
    });
  });
}
