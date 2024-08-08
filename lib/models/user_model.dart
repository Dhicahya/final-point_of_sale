import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // For JSON serialization

@JsonSerializable()
class UserModel extends Equatable {
  final String? id;
  final String email;
  final String name;
  final String avatar;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  get access_token => null;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatar, password];
}
