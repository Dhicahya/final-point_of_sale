import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_sanber/models/product_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PaymentBloc() : super(PaymentInitial()) {
    on<SubmitPayment>(_onSubmitPayment);
  }

  Future<void> _onSubmitPayment(
    SubmitPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      await _savePaymentData(
        event.products,
        event.quantities,
        event.paymentMethod,
      );
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _savePaymentData(
    List<Product> products,
    Map<String, int> quantities,
    String paymentMethod,
  ) async {
    final paymentData = {
      'date': DateTime.now(),
      'products': products
          .map((p) => {
                'name': p.name,
                'quantity': quantities[p.id],
                'price': p.price,
              })
          .toList(),
      'paymentMethod': paymentMethod,
      'status': 'loading', // Update this based on payment status
    };

    await _firestore.collection('payments').add(paymentData);
  }
}
