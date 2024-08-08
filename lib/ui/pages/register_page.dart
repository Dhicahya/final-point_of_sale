import 'package:finalproject_sanber/logic/auth_bloc/auth_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/widgets/custom_filled_button.dart';
import 'package:finalproject_sanber/ui/widgets/text_field.dart';
import 'package:finalproject_sanber/ui/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerEmail = TextEditingController();
    TextEditingController controllerPassword = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.userData != null) {
            ToastMessage(
              context: context,
              type: ToastificationType.success,
              message: 'Successfully Registered',
            ).toastCustom();
            Navigator.pushNamed(context, '/login');
          } else if (state.errorMessage.isNotEmpty) {
            ToastMessage(
              context: context,
              type: ToastificationType.error,
              message: state.errorMessage,
            ).toastCustom();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 85, right: 25, left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register Account',
                  style: blackColorStyle.copyWith(
                    fontSize: 25,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter your email, password, and username to register.',
                  style: greyColorStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
                const SizedBox(height: 60),
                CustomTextField(
                  contoller: controllerEmail,
                  hintText: 'Enter your email address',
                  labelText: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  contoller: controllerName,
                  hintText: 'Enter your username',
                  labelText: 'Username',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  contoller: controllerPassword,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CustomFilledButton(
                        text: CircularProgressIndicator(),
                      );
                    }
                    return CustomFilledButton(
                      text: Text(
                        'Sign Up',
                        style: whiteTextStyle,
                      ),
                      onPressed: () {
                        if (controllerName.text.isNotEmpty &&
                            controllerPassword.text.isNotEmpty &&
                            controllerEmail.text.isNotEmpty) {
                          context.read<AuthBloc>().add(
                                AuthRegister(
                                  email: controllerEmail.text,
                                  name: controllerName.text,
                                  password: controllerPassword.text,
                                ),
                              );
                        } else {
                          ToastMessage(
                            message: "All fields must be filled",
                            context: context,
                            type: ToastificationType.info,
                          ).toastCustom();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?  ',
                      style: greyColorStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Sign In',
                        style: blueColorStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
