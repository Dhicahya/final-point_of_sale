import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:finalproject_sanber/logic/payment_bloc/payment_bloc.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:finalproject_sanber/ui/pages/payment_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';

class CashPaymentPage extends StatefulWidget {
  final double totalPrice;
  final List<Product> products;
  final Map<String, int> quantities;

  const CashPaymentPage({
    required this.totalPrice,
    required this.products,
    required this.quantities,
    Key? key,
  }) : super(key: key);

  @override
  _CashPaymentPageState createState() => _CashPaymentPageState();
}

class _CashPaymentPageState extends State<CashPaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  double? _change;
  final String _transactionId = Uuid().v4(); // Generate a unique transaction ID

  void _calculateChange() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount >= widget.totalPrice) {
      setState(() {
        _change = amount - widget.totalPrice;
      });
    } else {
      setState(() {
        _change = null;
      });
    }
  }

  void _confirmPayment() {
    if (_change != null && _change! >= 0) {
      final transactionId = _generateTransactionId(); // Generate transaction ID

      // Trigger the PaymentBloc to handle cash payment
      context.read<PaymentBloc>().add(
            SubmitPayment(
              products: widget.products,
              quantities: widget.quantities,
              paymentMethod: 'Cash',
            ),
          );

      // Navigate to PaymentSuccessPage after payment is handled
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            paymentMethod: 'Cash',
            totalPrice: widget.totalPrice,
            transactionId: transactionId,
          ),
        ),
      );
    }
  }

  String _generateTransactionId() {
    final random = Random();
    return 'TXN-${random.nextInt(1000000)}'; // Generates a random 6-digit transaction ID
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment',
            style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular)),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Total Price: \Rp ${widget.totalPrice.toStringAsFixed(2)}',
                style:
                    blackColorStyle.copyWith(fontSize: 18, fontWeight: bold)),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _calculateChange(),
            ),
            const SizedBox(height: 16.0),
            if (_change != null)
              Text('Change: \Rp ${_change!.toStringAsFixed(2)}',
                  style:
                      blackColorStyle.copyWith(fontSize: 18, fontWeight: bold)),
            if (_change == null && _amountController.text.isNotEmpty)
              Text('Insufficient amount',
                  style:
                      redColorStyle.copyWith(fontSize: 18, fontWeight: bold)),
            Spacer(),
            ElevatedButton(
              onPressed: _confirmPayment,
              child: Text('Confirm Payment',
                  style:
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
