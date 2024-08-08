import 'package:finalproject_sanber/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton(
      {super.key, this.onPressed, required this.text, this.color});
  final VoidCallback? onPressed;
  final Widget text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color ?? blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: text,
      ),
    );
  }
}
