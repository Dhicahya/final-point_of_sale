import 'dart:math';

import 'package:finalproject_sanber/logic/payment_bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:finalproject_sanber/ui/pages/payment_success_page.dart';

class BankDetailPage extends StatelessWidget {
  final String bank;
  final double totalPrice;
  final List<Product> products; // Added to receive products
  final Map<String, int> quantities; // Added to receive quantities

  const BankDetailPage({
    required this.bank,
    required this.totalPrice,
    required this.products, // Added required parameter
    required this.quantities, // Added required parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank Details',
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Container(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bank: $bank',
                style: blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                style: blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _confirmBankTransfer(context);
                },
                child: Text(
                  'Confirm Bank Transfer',
                  style:
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBankTransfer(BuildContext context) {
    // Trigger the PaymentBloc to handle bank transfer
    context.read<PaymentBloc>().add(
          SubmitPayment(
            products: products,
            quantities: quantities,
            paymentMethod: 'Bank Transfer',
          ),
        );

    final transactionId = _generateTransactionId(); // Generate transaction ID

    // Navigate to PaymentSuccessPage after payment is handled
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(
          paymentMethod: 'Bank Transfer',
          totalPrice: totalPrice,
          transactionId: transactionId,
        ),
      ),
    );
  }

  String _generateTransactionId() {
    final random = Random();
    return 'TXN-${random.nextInt(1000000)}'; // Generates a random 6-digit transaction ID
  }
}
