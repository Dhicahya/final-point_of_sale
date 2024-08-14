import 'dart:math'; // Import this for random transaction ID generation
import 'package:equatable/equatable.dart';
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
      final transactionId = _generateTransactionId();

      if (event.paymentMethod == 'Cash') {
        // Handle cash payment
        await _savePaymentData(
          event.products,
          event.quantities,
          event.paymentMethod,
          transactionId: transactionId,
          status: 'success', // Immediately set status to success
        );
        emit(PaymentSuccess(transactionId: transactionId));
      } else if (event.paymentMethod == 'Bank Transfer') {
        // Handle bank transfer payment
        await _savePaymentData(
          event.products,
          event.quantities,
          event.paymentMethod,
          transactionId: transactionId,
          status: 'loading', // Set status to loading initially
        );

        // Simulate a delay for bank transfer
        await Future.delayed(Duration(seconds: 30));

        // Update payment status to success after delay
        await _updatePaymentStatus(transactionId);
        emit(PaymentSuccess(transactionId: transactionId));
      }
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  String _generateTransactionId() {
    final random = Random();
    return 'TXN-${random.nextInt(1000000)}'; // Generates a random 6-digit transaction ID
  }

  Future<void> _savePaymentData(
    List<Product> products,
    Map<String, int> quantities,
    String paymentMethod, {
    required String transactionId,
    required String status,
  }) async {
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
      'status': status,
      'transactionId': transactionId, // Save transaction ID
    };

    await _firestore.collection('payments').add(paymentData);
  }

  Future<void> _updatePaymentStatus(String transactionId) async {
    // Retrieve the latest payment document with the transactionId
    final querySnapshot = await _firestore
        .collection('payments')
        .where('transactionId', isEqualTo: transactionId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('payments').doc(docId).update({
        'status': 'success',
      });
    }
  }
}
