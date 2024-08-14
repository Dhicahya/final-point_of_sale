import 'package:flutter/material.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:finalproject_sanber/ui/pages/bank_detail_page.dart';

class BankSelectionPage extends StatelessWidget {
  final double totalPrice;
  final List<Product> products;
  final Map<String, int> quantities;

  const BankSelectionPage({
    required this.totalPrice,
    required this.products,
    required this.quantities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final banks = {
      'Mandiri': 'assets/icons/bank_mandiri_icon.png',
      'BRI': 'assets/icons/bank_bri_icon.png',
      'BNI': 'assets/icons/bank_bni_icon.png',
      'BCA': 'assets/icons/bank_bca_icon.png',
      'CIMB': 'assets/icons/bank_cimb_icon.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Bank',
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Container(
        color: whiteColor,
        child: ListView.separated(
          itemCount: banks.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200], // Color for the divider
            height: 1.0, // Height of the divider
          ),
          itemBuilder: (context, index) {
            final bank = banks.keys.elementAt(index);
            final imagePath = banks[bank]!;

            return ListTile(
              leading: imagePath.endsWith('.png')
                  ? Image.asset(imagePath, width: 40, height: 40)
                  : Icon(Icons.help_outline, color: blueColor), // Fallback icon
              title: Text(bank),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BankDetailPage(
                      bank: bank,
                      totalPrice: totalPrice,
                      products: products,
                      quantities: quantities,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
