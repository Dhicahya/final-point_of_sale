import 'package:finalproject_sanber/ui/pages/bank_selection_page.dart';
import 'package:finalproject_sanber/ui/pages/cash_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:finalproject_sanber/shared/theme.dart';

class OrderDetailPage extends StatelessWidget {
  final List<Product> products;
  final Map<String, int> quantities;

  const OrderDetailPage({
    required this.products,
    required this.quantities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int totalItems = 0;
    double totalPrice = 0.0;

    List<Widget> productWidgets = [];

    for (var product in products) {
      final quantity = quantities[product.id] ?? 0;
      if (quantity > 0) {
        totalItems += quantity;
        totalPrice += product.price * quantity;

        productWidgets.add(
          Card(
            color: blueColor,
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product.name,
                  style: whiteTextStyle.copyWith(fontWeight: bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Quantity: $quantity',
                    style: whiteTextStyle,
                  ),
                  Text(
                    'Price: \Rp ${(product.price * quantity).toStringAsFixed(2)}',
                    style: whiteTextStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Container(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (productWidgets.isEmpty)
                Center(
                    child: Text(
                  'No products ordered.',
                  style: blackColorStyle,
                ))
              else
                Expanded(
                  child: ListView(
                    children: productWidgets,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Items: $totalItems',
                  style:
                      blackColorStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                  style:
                      blackColorStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the detail page
                      },
                      child: Text(
                        'Cancel',
                        style: redColorStyle.copyWith(
                            fontSize: 14, fontWeight: regular),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red), // Outline color
                        backgroundColor:
                            Colors.white, // Button background color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Add space between buttons
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (products.isEmpty || quantities.isEmpty) {
                          // Show alert if no products are ordered
                          _showNoProductsAlert(context);
                        } else {
                          _showPaymentModal(
                              context, totalPrice); // Pass totalPrice here
                        }
                      },
                      child: Text(
                        'Proceed to Payment',
                        style: blueColorStyle.copyWith(
                            fontSize: 14, fontWeight: regular),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue), // Outline color
                        backgroundColor:
                            Colors.white, // Button background color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0), // Add space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentModal(BuildContext context, double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: Text(
            'Select Payment Method',
            style: blackColorStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CashPaymentPage(
                        totalPrice: totalPrice, // Pass totalPrice here
                        products: products, // Pass products here
                        quantities: quantities, // Pass quantities here
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.money, color: yellowColor),
                    const SizedBox(width: 8.0),
                    Text(
                      'Pay with Cash',
                      style: yellowColorStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: yellowColor,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: yellowColor),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BankSelectionPage(
                        totalPrice: totalPrice,
                        products: products,
                        quantities: quantities,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.account_balance, color: greenColor),
                    const SizedBox(width: 8.0),
                    Text(
                      'Pay with Bank Transfer',
                      style: greenColorStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: greenColor,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: greenColor),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNoProductsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: Text(
            'No Products Ordered',
            style: blackColorStyle,
          ),
          content: Text(
            'You need to add products to your order before proceeding to payment.',
            style: blackColorStyle,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text(
                'OK',
                style: blueColorStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
