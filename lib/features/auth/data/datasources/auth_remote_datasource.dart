import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
  Future<UserModel> fetchCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final Response<Map<String, dynamic>> response =
        await _dio.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: <String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
      options: Options(extra: <String, dynamic>{'skipAuth': true}),
    );
    return UserModel.fromJson(response.data!);
  }

  @override
  Future<UserModel> fetchCurrentUser() async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>(ApiConstants.me);
    return UserModel.fromJson(response.data!);
  }
}
