import '../../domain/entities/user_entity.dart';

/// DummyJSON's `/auth/login` and `/auth/me` responses share this shape.
/// Parsing is written by hand (no generated code) so the model has zero
/// build_runner dependency and stays trivial to unit test.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.image,
    this.accessToken,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      image: json['image'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  final String? accessToken;
  final String? refreshToken;

  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        image: image,
      );
}
