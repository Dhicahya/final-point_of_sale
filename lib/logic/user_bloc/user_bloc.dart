import 'package:equatable/equatable.dart';
import 'package:finalproject_sanber/models/user_model.dart';
import 'package:finalproject_sanber/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitialState()) {
    on<UserCreateEvent>((event, emit) async {
      emit(UserLoadingData());
      try {
        final UserModel user = UserModel(
          email: event.email,
          avatar: event.avatar,
          name: event.name,
          password: event.password,
        );
        final response = await userService.createUser(user);
        emit(UserRegisterData(hasil: response));
      } catch (e) {
        emit(UserErrorData(error: e.toString()));
      }
    });

    on<UserLoginEvent>((event, emit) async {
      emit(UserLoadingData());
      try {
        final response = await userService.loginUser({
          'email': event.email,
          'password': event.password,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('token', response.access_token.toString());
        emit(UserLoginData(hasil: response));
      } catch (e) {
        emit(UserLoginError(error: e.toString()));
      }
    });

    on<UserUpdateEvent>((event, emit) async {
      emit(UserLoadingData());
      try {
        final UserModel user = UserModel(
          email: event.email,
          name: event.name,
          password: event.password,
          avatar: event.avatar,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final response = await userService.updateUser(
            user, prefs.getString('id').toString());
        emit(UserUpdateLoaded(hasil: response));
      } catch (e) {
        emit(UserUpdateError(error: e.toString()));
      }
    });

    on<UserGetProfileEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final response =
            await userService.getUser(prefs.getString('id').toString());
        emit(UserGetProfile(hasil: response));
      } catch (e) {
        emit(UserErrorData(error: e.toString()));
      }
    });

    on<UserLogoutEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        emit(UserLogout());
      } catch (e) {
        emit(UserErrorData(error: e.toString()));
      }
    });
  }
}
