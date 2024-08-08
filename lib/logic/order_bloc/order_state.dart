part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderSuccess extends OrderState {
  final int totalOrders; // Add this field to track total orders

  const OrderSuccess(this.totalOrders);

  @override
  List<Object> get props => [totalOrders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
