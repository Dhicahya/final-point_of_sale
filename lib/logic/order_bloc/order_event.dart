part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddOrder extends OrderEvent {
  final String productId;
  final int quantity;

  const AddOrder({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}
