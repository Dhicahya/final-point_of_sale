import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int stock;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      stock: data['stock'] ?? 0,
      price: data['price'] ?? double,
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
