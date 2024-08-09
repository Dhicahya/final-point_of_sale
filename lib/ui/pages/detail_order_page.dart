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
    // Calculate total item count and total price
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
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Quantity: $quantity'),
                  Text(
                      'Price: \Rp ${(product.price * quantity).toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details',
        style: blackColorStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (productWidgets.isEmpty)
              const Center(child: Text('No products ordered.'))
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
                style: blackColorStyle.copyWith(fontSize: 16,fontWeight: bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                style: blackColorStyle.copyWith(fontSize: 16, fontWeight: bold),
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
                      backgroundColor: Colors.white, // Button background color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0), // Add space between buttons
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showPaymentModal(context);
                    },
                    child: Text(
                      'Proceed to Payment',
                      style: blueColorStyle.copyWith(
                          fontSize: 14, fontWeight: regular),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue), // Outline color
                      backgroundColor: Colors.white, // Button background color
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
    );
  }

  void _showPaymentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle cash payment logic here
                },
                child: Text(
                  'Pay with Cash',
                  style: blueColorStyle.copyWith(
                      fontSize: 14, fontWeight: regular),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue), // Outline color
                  backgroundColor: Colors.white, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle bank transfer payment logic here
                },
                child: Text(
                  'Pay with Bank Transfer',
                  style: blueColorStyle.copyWith(
                      fontSize: 14, fontWeight: regular),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue), // Outline color
                  backgroundColor: Colors.white, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
