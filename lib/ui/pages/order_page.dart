import 'package:badges/badges.dart' as badges;
import 'package:finalproject_sanber/shared/theme.dart';
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
  int _totalOrderCount = 0; // Track total order count for badge

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order',
        style: blackColorStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
      ),
      body: Container(
        color: whiteColor,
        child: BlocBuilder<InventoryBloc, InventoryState>(
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
                        Text('Stock: ${product.stock}',
                        style: whiteTextStyle.copyWith(fontWeight: regular),),
                        Text('Price: \Rp ${product.price.toStringAsFixed(2)}',
                        style: whiteTextStyle.copyWith(fontWeight: regular)),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.remove, color: whiteColor,),
                              onPressed: () {
                                _updateQuantity(product.id, -1);
                              },
                            ),
                            Text(_quantities[product.id]?.toString() ?? '0', 
                            style: whiteTextStyle.copyWith(fontWeight: regular, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add, color: whiteColor,),
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
                              _updateTotalOrderCount();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Stock is not sufficient')),
                            );
                          }
                        }
                      },
                      child: Text('Order',
                      style: blueColorStyle.copyWith(fontWeight: regular)),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No products available.'));
          }
        },
      ),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: () {
          final inventoryState = context.read<InventoryBloc>().state;
          if (inventoryState is InventoryLoaded) {
            final products = inventoryState.products;
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
            _totalOrderCount.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_cart, color: whiteColor,),
        ),
      ),
    );
  }

  void _updateQuantity(String productId, int change) {
    setState(() {
      final currentQuantity = _quantities[productId] ?? 0;
      final newQuantity =
          (currentQuantity + change).clamp(0, double.infinity).toInt();
      _quantities[productId] = newQuantity;
      _updateTotalOrderCount();
    });
  }

  void _updateTotalOrderCount() {
    setState(() {
      _totalOrderCount = _quantities.values.fold(0, (sum, qty) => sum + qty);
    });
  }
}
