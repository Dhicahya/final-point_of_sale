import 'package:badges/badges.dart' as badges;
import 'package:finalproject_sanber/ui/pages/detail_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject_sanber/logic/order_bloc/order_bloc.dart';
import 'package:finalproject_sanber/logic/inventory_bloc/inventory_bloc.dart';
import 'package:finalproject_sanber/models/product_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final Map<String, int> _quantities = {}; // Track quantities for each product

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
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                _updateQuantity(product.id, -1);
                              },
                            ),
                            Text(_quantities[product.id]?.toString() ?? '0'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _updateQuantity(product.id, 1);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final quantity = _quantities[product.id] ?? 0;
                        if (quantity > 0) {
                          if (product.stock >= quantity) {
                            context.read<OrderBloc>().add(AddOrder(
                                  productId: product.id,
                                  quantity: quantity,
                                ));
                            // Clear the quantity after adding the order
                            setState(() {
                              _quantities[product.id] = 0;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Stock is not sufficient')),
                            );
                          }
                        }
                      },
                      child: const Text('Order'),
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
                final inventoryState = context.read<InventoryBloc>().state;
                if (inventoryState is InventoryLoaded) {
                  final products = inventoryState.products;
                  print('Quantities: $_quantities'); // Debugging
                  print(
                      'Products: ${products.map((p) => p.name).toList()}'); // Debugging
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                      products: products,
                      quantities: _quantities,
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to load products')),
                  );
                }
              },
              child: badges.Badge(
                badgeContent: Text(
                  orderCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            );
          },
        )
    );
  }

  void _updateQuantity(String productId, int change) {
    setState(() {
      final currentQuantity = _quantities[productId] ?? 0;
      final newQuantity =
          (currentQuantity + change).clamp(0, double.infinity).toInt();
      _quantities[productId] = newQuantity;
    });
  }
}
