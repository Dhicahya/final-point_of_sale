import 'package:flutter/material.dart';
import 'package:finalproject_sanber/shared/theme.dart';

class BankSelectionPage extends StatelessWidget {
  const BankSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final banks = ['Mandiri', 'BRI', 'BNI', 'BCA'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Bank',
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(banks[index]),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankDetailPage(bank: banks[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BankDetailPage extends StatelessWidget {
  final String bank;

  const BankDetailPage({required this.bank, super.key});

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
      body: Center(
        child: Text(
          'Details for $bank',
          style: blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
        ),
      ),
    );
  }
}
