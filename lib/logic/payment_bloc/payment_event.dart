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

  const SubmitPayment({
    required this.products,
    required this.quantities,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [products, quantities, paymentMethod];
}
