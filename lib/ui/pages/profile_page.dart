import 'package:finalproject_sanber/logic/user_bloc/user_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/widgets/custom_filled_button.dart';
import 'package:finalproject_sanber/ui/widgets/text_field.dart';
import 'package:finalproject_sanber/ui/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toastification/toastification.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdateLoaded) {
            ToastMessage(
                    context: context,
                    type: ToastificationType.success,
                    message: 'Success Update Profile')
                .toastCustom();
          } else if (state is UserUpdateError) {
            ToastMessage(
                    context: context,
                    type: ToastificationType.error,
                    message: 'Failed Update Profile')
                .toastCustom();
          } else if (state is UserLogout) {
            ToastMessage(
                    context: context,
                    message: 'Success Logout',
                    type: ToastificationType.success)
                .toastCustom();
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(top: 120, left: 25, right: 25, bottom: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile & Password',
                style: blackColorStyle.copyWith(fontWeight: bold, fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Lengkapi data terakhir berikut untuk masuk ke\naplikasi Mega Shop',
                style: greyColorStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  TextEditingController? controllerName;
                  TextEditingController? controllerEmail;
                  TextEditingController? controllerPassword;

                  if (state is UserGetProfile) {
                    controllerName =
                        TextEditingController(text: state.hasil.name);
                    controllerEmail =
                        TextEditingController(text: state.hasil.email);
                    controllerPassword =
                        TextEditingController(text: state.hasil.password);

                    return Column(
                      children: [
                        form(controllerName, controllerEmail,
                            controllerPassword),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            return CustomFilledButton(
                              onPressed: () {
                                context.read<UserBloc>().add(
                                      UserUpdateEvent(
                                        email: controllerEmail!.text,
                                        name: controllerName!.text,
                                        password: controllerPassword!.text,
                                      ),
                                    );
                              },
                              text: Text(
                                'Update',
                                style: whiteTextStyle,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is UserUpdateLoaded) {
                    controllerName =
                        TextEditingController(text: state.hasil.name);
                    controllerEmail =
                        TextEditingController(text: state.hasil.email);
                    controllerPassword =
                        TextEditingController(text: state.hasil.password);

                    return Column(
                      children: [
                        form(controllerName, controllerEmail,
                            controllerPassword),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            return CustomFilledButton(
                              onPressed: () {
                                context.read<UserBloc>().add(
                                      UserUpdateEvent(
                                        email: controllerEmail!.text,
                                        name: controllerName!.text,
                                        password: controllerPassword!.text,
                                      ),
                                    );
                              },
                              text: Text(
                                'Update',
                                style: whiteTextStyle,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  // Handle other states or provide default UI here
                  return Container();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return CustomFilledButton(
                    color: Colors.red,
                    onPressed: () {
                      context.read<UserBloc>().add(UserLogoutEvent());
                    },
                    text: Text(
                      'Logout',
                      style: whiteTextStyle,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form(controllerName, controllerEmail, controllerPassword) {
    return Column(
      children: [
        CustomTextField(
          contoller: controllerName,
          hintText: '',
          labelText: 'Full Name',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          contoller: controllerEmail,
          hintText: '',
          labelText: 'Email',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          contoller: controllerPassword,
          hintText: '',
          labelText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.warning_outlined,
              color: Color(0xff838589),
            ),
            const SizedBox(width: 10),
            Text(
              'Kata sandi harus 6 karakter atau lebih',
              style: greyColorStyle.copyWith(
                fontWeight: regular,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
