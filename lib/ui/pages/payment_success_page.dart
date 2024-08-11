import 'package:flutter/material.dart';
import 'package:finalproject_sanber/shared/theme.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment Success',
            style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
          ),
          backgroundColor: blueColor,
          iconTheme: IconThemeData(color: whiteColor),
        ),
        body: Container(
          color: whiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Payment was successful!',
                  style:
                      blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  child: Text(
                    'Back to Orders',
                    style: whiteTextStyle.copyWith(
                        fontSize: 16, fontWeight: regular),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor, // Button background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
