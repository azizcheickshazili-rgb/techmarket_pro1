import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket_pro1/core/storage/secure_storage_service.dart';
import 'package:techmarket_pro1/core/utils/result.dart';
import 'package:techmarket_pro1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:techmarket_pro1/features/auth/data/models/user_model.dart';
import 'package:techmarket_pro1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:techmarket_pro1/features/auth/domain/entities/user_entity.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late _MockAuthRemoteDataSource remoteDataSource;
  late _MockSecureStorageService secureStorage;
  late AuthRepositoryImpl repository;

  const UserModel fakeUserModel = UserModel(
    id: 1,
    username: 'emilys',
    email: 'emily@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    accessToken: 'jwt-access',
    refreshToken: 'jwt-refresh',
  );

  setUp(() {
    remoteDataSource = _MockAuthRemoteDataSource();
    secureStorage = _MockSecureStorageService();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      secureStorage: secureStorage,
    );
    when(() => secureStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        )).thenAnswer((_) async {});
  });

  group('AuthRepositoryImpl.login', () {
    test('persists tokens and returns Ok(UserEntity) on success', () async {
      when(() => remoteDataSource.login(username: 'emilys', password: 'emilyspass'))
          .thenAnswer((_) async => fakeUserModel);

      final Result<UserEntity> result =
          await repository.login(username: 'emilys', password: 'emilyspass');

      expect(result.isOk, isTrue);
      verify(() => secureStorage.saveTokens(
            accessToken: 'jwt-access',
            refreshToken: 'jwt-refresh',
          )).called(1);
    });

    test('maps 400/401 DioException to AuthFailure', () async {
      when(() => remoteDataSource.login(username: any(named: 'username'), password: any(named: 'password')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      ));

      final Result<UserEntity> result =
          await repository.login(username: 'wrong', password: 'wrong');

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('expected Err'),
        err: (Failure failure) => expect(failure, isA<AuthFailure>()),
      );
    });

    test('maps connection errors to NetworkFailure', () async {
      when(() => remoteDataSource.login(username: any(named: 'username'), password: any(named: 'password')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
      ));

      final Result<UserEntity> result =
          await repository.login(username: 'emilys', password: 'emilyspass');

      result.when(
        ok: (_) => fail('expected Err'),
        err: (Failure failure) => expect(failure, isA<NetworkFailure>()),
      );
    });
  });
}
