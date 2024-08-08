import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    monitorAuthState();

    on<AuthRegister>((event, emit) async {
      emit(const AuthState(isLoading: true));
      try {
        final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Update user profile with name
        await res.user!.updateProfile(displayName: event.name);

        // Save user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.user!.uid)
            .set({
          'uid': res.user!.uid,
          'email': event.email,
          'name': event.name, // Save the name as well
        });

        emit(AuthState(userData: res.user));
      } catch (e) {
        emit(AuthState(errorMessage: e.toString()));
      }
    });

    on<AuthLogin>((event, emit) async {
      emit(const AuthState(isLoading: true));
      try {
        final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthState(userData: res.user));
      } catch (e) {
        emit(AuthState(errorMessage: e.toString()));
      }
    });

    on<AuthUpdated>((event, emit) {
      emit(AuthState(userData: event.userData));
    });
  }

  void monitorAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthUpdated(userData: user));
      } else {
        add(AuthUpdated(userData: null)); // Handle sign-out state
      }
    });
  }
}
