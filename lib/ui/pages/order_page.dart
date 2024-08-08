import 'package:badges/badges.dart' as badges; // Prefix for the badges package
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject_sanber/logic/order_bloc/order_bloc.dart';
import 'package:finalproject_sanber/logic/inventory_bloc/inventory_bloc.dart';
import 'package:finalproject_sanber/models/product_model.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is InventoryLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Card(
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
                        Text('Stock: ${product.stock}'),
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _showOrderDialog(context, product);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No products available.'));
          }
        },
      ),
      floatingActionButton: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final orderCount = state is OrderSuccess ? state.totalOrders : 0;
          return FloatingActionButton(
            onPressed: () {
              // Handle button press for total orders
            },
            child: badges.Badge(
              badgeContent: Text(
                orderCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              child: const Icon(Icons.shopping_cart),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDialog(BuildContext context, Product product) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Product: ${product.name}'),
              Text('Stock: ${product.stock}'),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Order'),
              onPressed: () {
                final quantity = int.tryParse(quantityController.text);

                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid quantity')),
                  );
                  return;
                }

                if (product.stock < quantity) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stock is not sufficient')),
                  );
                  return;
                }

                context.read<OrderBloc>().add(AddOrder(
                      productId: product.id,
                      quantity: quantity,
                    ));

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
