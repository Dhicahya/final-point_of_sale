import 'package:finalproject_sanber/logic/auth_bloc/auth_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/widgets/custom_filled_button.dart';
import 'package:finalproject_sanber/ui/widgets/text_field.dart';
import 'package:finalproject_sanber/ui/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerEmail = TextEditingController();
    TextEditingController controllerPassword = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.userData != null) {
            Navigator.pushNamed(context, '/home');
            ToastMessage(
              context: context,
              message: 'Successfully Logged In',
              type: ToastificationType.success,
            ).toastCustom();
          } else if (state.errorMessage.isNotEmpty) {
            ToastMessage(
              context: context,
              message: 'Failed to Log In',
              type: ToastificationType.error,
            ).toastCustom();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(right: 25, left: 25, top: 127),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back to\nMega Mall',
                  style:
                      blackColorStyle.copyWith(fontSize: 25, fontWeight: bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please enter your login details',
                  style: greyColorStyle.copyWith(
                      fontSize: 14, fontWeight: regular),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    CustomTextField(
                      hintText: 'Enter your email address',
                      labelText: 'Email',
                      contoller: controllerEmail,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      obscureText: true,
                      contoller: controllerPassword,
                    ),
                    const SizedBox(height: 70),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const CustomFilledButton(
                            text: CircularProgressIndicator(),
                          );
                        }
                        return CustomFilledButton(
                          text: Text(
                            'Sign In',
                            style: whiteTextStyle,
                          ),
                          onPressed: () {
                            if (controllerPassword.text.isNotEmpty &&
                                controllerEmail.text.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                    AuthLogin(
                                      email: controllerEmail.text,
                                      password: controllerPassword.text,
                                    ),
                                  );
                            } else {
                              ToastMessage(
                                context: context,
                                message: "Value Can't Be Empty",
                                type: ToastificationType.info,
                              ).toastCustom();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 102),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: blackColorStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Sign Up',
                        style: blueColorStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 14,
                        ),
                      ),
                    )
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
