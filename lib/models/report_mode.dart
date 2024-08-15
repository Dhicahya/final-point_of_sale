import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String orderId;
  final String productId;
  final int quantity;
  final double price;
  final double totalPrice;
  final String paymentMethod;
  final DateTime transactionDate;

  Report({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.paymentMethod,
    required this.transactionDate,
  });

  factory Report.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Report(
      orderId: data['orderId'],
      productId: data['productId'],
      quantity: data['quantity'],
      price: data['price'],
      totalPrice: data['totalPrice'],
      paymentMethod: data['paymentMethod'],
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
    );
  }
}
