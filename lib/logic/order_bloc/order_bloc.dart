import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _totalOrders = 0; // To track total orders

  OrderBloc() : super(OrderInitial());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is AddOrder) {
      try {
        final productDoc =
            _firestore.collection('products').doc(event.productId);
        final productSnapshot = await productDoc.get();
        final product = Product.fromFirestore(productSnapshot);

        if (product.stock < event.quantity) {
          yield OrderError('Stock is not sufficient');
        } else {
          await productDoc.update({
            'stock': product.stock - event.quantity,
          });

          _totalOrders += event.quantity; // Update total orders
          yield OrderSuccess(_totalOrders);
        }
      } catch (e) {
        yield OrderError(e.toString());
      }
    }
  }
}
