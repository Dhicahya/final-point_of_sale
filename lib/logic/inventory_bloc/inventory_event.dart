// inventory_event.dart
part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends InventoryEvent {}

class AddProduct extends InventoryEvent {
  final String name;
  final int stock;
  final double price;
  final String imageUrl;

  const AddProduct({
    required this.name,
    required this.stock,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [name, stock, imageUrl];
}

class UpdateProduct extends InventoryEvent {
  final String id;
  final String name;
  final int stock;
  final double price;
  final String imageUrl;

  const UpdateProduct({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, name, stock];
}

class DeleteProduct extends InventoryEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object> get props => [id];
}
