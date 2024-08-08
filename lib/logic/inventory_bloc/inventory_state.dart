part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<Product> products;

  InventoryLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}
