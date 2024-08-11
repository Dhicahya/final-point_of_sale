part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class SubmitPayment extends PaymentEvent {
  final List<Product> products;
  final Map<String, int> quantities;
  final String paymentMethod;

  SubmitPayment({
    required this.products,
    required this.quantities,
    required this.paymentMethod,
  });
}
