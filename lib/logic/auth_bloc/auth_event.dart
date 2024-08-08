part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegister extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const AuthRegister({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [email, name, password];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthUpdated extends AuthEvent {
  final User? userData;

  const AuthUpdated({required this.userData});

  @override
  List<Object?> get props => [userData];
}
