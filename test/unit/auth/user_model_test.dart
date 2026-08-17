import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket_pro1/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('parses a full DummyJSON /auth/login response', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'jwt-access',
        'refreshToken': 'jwt-refresh',
      };

      final UserModel model = UserModel.fromJson(json);

      expect(model.id, 1);
      expect(model.username, 'emilys');
      expect(model.fullName, 'Emily Johnson');
      expect(model.accessToken, 'jwt-access');
    });

    test('falls back to empty strings when optional name fields are missing', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 2,
        'username': 'guest',
        'email': 'guest@example.com',
      };

      final UserModel model = UserModel.fromJson(json);

      expect(model.firstName, '');
      expect(model.lastName, '');
      expect(model.image, isNull);
    });

    test('toEntity() strips the tokens and keeps profile fields', () {
      const UserModel model = UserModel(
        id: 3,
        username: 'x',
        email: 'x@x.com',
        firstName: 'X',
        lastName: 'Y',
        accessToken: 'secret',
      );

      final dynamic entity = model.toEntity();
      expect(entity.id, 3);
      expect(entity.runtimeType.toString(), 'UserEntity');
    });
  });
}
