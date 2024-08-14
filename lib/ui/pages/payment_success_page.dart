// payment_success_page.dart
import 'package:flutter/material.dart';
import 'package:finalproject_sanber/shared/theme.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentMethod;
  final double totalPrice;
  final String transactionId;

  const PaymentSuccessPage({
    required this.paymentMethod,
    required this.totalPrice,
    required this.transactionId,
    super.key,
  });

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Payment was successful!',
                  style:
                      blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Payment Method: $paymentMethod',
                  style: blackColorStyle.copyWith(fontSize: 16),
                ),
                Text(
                  'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                  style: blackColorStyle.copyWith(fontSize: 16),
                ),
                Text(
                  'Transaction ID: $transactionId',
                  style: blackColorStyle.copyWith(fontSize: 16),
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
        ),
      ),
    );
  }
}
