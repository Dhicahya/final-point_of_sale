import 'package:finalproject_sanber/firebase_option.dart';
import 'package:finalproject_sanber/logic/auth_bloc/auth_bloc.dart';
import 'package:finalproject_sanber/logic/cart_bloc/cart_bloc.dart';
import 'package:finalproject_sanber/logic/inventory_bloc/inventory_bloc.dart';
import 'package:finalproject_sanber/logic/user_bloc/user_bloc.dart';
import 'package:finalproject_sanber/services/user_service.dart';
import 'package:finalproject_sanber/ui/pages/login_page.dart';
import 'package:finalproject_sanber/ui/pages/register_page.dart';
import 'package:finalproject_sanber/ui/pages/splash_screen.dart';
import 'package:finalproject_sanber/ui/layout_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Remove the UserService instance if no longer needed
  // final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userService: UserService()),
        ),
        BlocProvider<InventoryBloc>(
          create: (context) => InventoryBloc()..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
        // BlocProvider<WhislistBloc>(create: (context) => WhislistBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        // Define routes for pages here
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const LayoutNavigation()
        },
      ),
    );
  }
}
