import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:flutter/rendering.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InventoryBloc() : super(InventoryInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      final snapshot = await _firestore.collection('products').get();
      final products =
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      emit(InventoryLoaded(products));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProduct event, Emitter<InventoryState> emit) async {
    try {
      await _firestore.collection('products').add({
        'name': event.name,
        'stock': event.stock,
        'price' : event.price,
        'imageUrl': event.imageUrl,
      });
      add(LoadProducts());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event, Emitter<InventoryState> emit) async {
    try {
      await _firestore.collection('products').doc(event.id).update({
        'name': event.name,
        'stock': event.stock,
        'price': event.price,
      });
      add(LoadProducts());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<InventoryState> emit) async {
    try {
      await _firestore.collection('products').doc(event.id).delete();
      add(LoadProducts());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
