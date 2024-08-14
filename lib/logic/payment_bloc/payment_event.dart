// payment_event.dart
part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class SubmitPayment extends PaymentEvent {
  final List<Product> products;
  final Map<String, int> quantities;
  final String paymentMethod;
  final String transactionId; // Ensure this is included
  final double totalPrice; // Ensure this is included

  const SubmitPayment({
    required this.products,
    required this.quantities,
    required this.paymentMethod,
    required this.transactionId,
    required this.totalPrice,
  });

  @override
  List<Object> get props =>
      [products, quantities, paymentMethod, transactionId, totalPrice];
}
