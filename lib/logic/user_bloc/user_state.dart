part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadingData extends UserState {}

class UserRegisterData extends UserState {
  final UserModel hasil;

  const UserRegisterData({required this.hasil});

  @override
  List<Object> get props => [hasil];
}

class UserLoginData extends UserState {
  final dynamic hasil;

  const UserLoginData({required this.hasil});

  @override
  List<Object> get props => [hasil];
}

class UserUpdateLoaded extends UserState {
  final UserModel hasil;

  const UserUpdateLoaded({required this.hasil});

  @override
  List<Object> get props => [hasil];
}

class UserGetProfile extends UserState {
  final UserModel hasil;

  const UserGetProfile({required this.hasil});

  @override
  List<Object> get props => [hasil];
}

class UserErrorData extends UserState {
  final String error;

  const UserErrorData({required this.error});

  @override
  List<Object> get props => [error];
}

class UserLoginError extends UserState {
  final String error;

  const UserLoginError({required this.error});

  @override
  List<Object> get props => [error];
}

class UserUpdateError extends UserState {
  final String error;

  const UserUpdateError({required this.error});

  @override
  List<Object> get props => [error];
}

class UserLogout extends UserState {}
