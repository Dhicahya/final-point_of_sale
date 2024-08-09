import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _totalOrders = 0;

  OrderBloc() : super(OrderInitial()) {
    on<AddOrder>(_onAddOrder);
  }

  Future<void> _onAddOrder(AddOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final productDoc = _firestore.collection('products').doc(event.productId);
      final productSnapshot = await productDoc.get();
      final product = Product.fromFirestore(productSnapshot);

      if (product.stock < event.quantity) {
        emit(OrderError('Stock is not sufficient'));
      } else {
        await productDoc.update({
          'stock': product.stock - event.quantity,
        });

        _totalOrders += event.quantity;
        emit(OrderSuccess(_totalOrders));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
