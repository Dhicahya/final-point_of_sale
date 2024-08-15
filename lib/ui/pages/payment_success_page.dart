import 'package:finalproject_sanber/ui/pages/pdf/pdf_format.dart';
import 'package:flutter/material.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentMethod;
  final double totalPrice;
  final String transactionId;
  final DateTime paymentDate;
  final List<Product> products;
  final Map<String, int> quantities;

  const PaymentSuccessPage({
    required this.paymentMethod,
    required this.totalPrice,
    required this.transactionId,
    required this.paymentDate,
    required this.products,
    required this.quantities,
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
                  'Transaction ID: $transactionId',
                  style: blackColorStyle.copyWith(fontSize: 16),
                ),
                Text(
                  'Payment Date: ${paymentDate.toLocal().toString()}',
                  style: blackColorStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Order Details:',
                  style:
                      blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
                const SizedBox(height: 10),
                ...products
                    .where((product) => quantities[product.id] != null)
                    .map((product) {
                  final quantity = quantities[product.id]!;
                  final price = product.price * quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.name} x $quantity',
                          style: blackColorStyle.copyWith(fontSize: 16),
                        ),
                        Text(
                          '\Rp ${price.toStringAsFixed(2)}',
                          style: blackColorStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Text(
                  'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                  style:
                      blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            backgroundColor: greyColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            final path = await generatePdf(
                              paymentMethod: paymentMethod,
                              totalPrice: totalPrice,
                              transactionId: transactionId,
                              paymentDate: paymentDate,
                              products: products,
                              quantities: quantities,
                            );
                            // Share the PDF file
                            Share.shareXFiles([XFile(path)],
                                text: 'Here is your payment summary.');
                            // Optionally, open the PDF file
                            OpenFile.open(path);
                          },
                          child: Text(
                            'Print PDF',
                            style: whiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: regular),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
