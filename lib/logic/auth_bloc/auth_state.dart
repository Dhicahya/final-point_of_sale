part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? userData;
  final bool isLoading;
  final String errorMessage;

  const AuthState({
    this.userData,
    this.isLoading = false,
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [userData, isLoading];
}
