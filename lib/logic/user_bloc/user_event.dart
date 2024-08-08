part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserCreateEvent extends UserEvent {
  final String email;
  final String name;
  final String password;
  final String avatar;

  const UserCreateEvent({
    required this.email,
    required this.name,
    required this.password,
    this.avatar = '',
  });

  @override
  List<Object> get props => [email, name, password, avatar];
}

class UserLoginEvent extends UserEvent {
  final String email;
  final String password;

  const UserLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class UserUpdateEvent extends UserEvent {
  final String email;
  final String name;
  final String password;
  final String avatar;

  const UserUpdateEvent({
    required this.email,
    required this.name,
    required this.password,
    this.avatar = '',
  });

  @override
  List<Object> get props => [email, name, password, avatar];
}

class UserGetProfileEvent extends UserEvent {}

class UserLogoutEvent extends UserEvent {}
