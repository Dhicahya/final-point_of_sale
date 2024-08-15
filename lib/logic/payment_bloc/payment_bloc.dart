// payment_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:uuid/uuid.dart'; // Import UUID package

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PaymentBloc() : super(PaymentInitial()) {
    on<SubmitPayment>(_onSubmitPayment);
  }

  String _generateTransactionId() {
    return Uuid().v4(); // Generates a unique ID
  }

  Future<void> _onSubmitPayment(
    SubmitPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final transactionId =
          _generateTransactionId(); // Generate a transaction ID

      if (event.paymentMethod == 'Cash') {
        // Handle cash payment
        await _savePaymentData(
          event.products,
          event.quantities,
          event.paymentMethod,
          transactionId: transactionId,
          paymentDate: DateTime.now(),
          status: 'success', // Immediately set status to success
        );
        emit(PaymentSuccess(
            transactionId:
                transactionId)); // Pass transactionId to success state
      } else if (event.paymentMethod == 'Bank Transfer') {
        // Handle bank transfer payment
        await _savePaymentData(
          event.products,
          event.quantities,
          event.paymentMethod,
          transactionId: transactionId,
          paymentDate: DateTime.now(),
          status: 'loading', // Set status to loading initially
        );

        // Simulate a delay for bank transfer
        await Future.delayed(Duration(seconds: 30));

        // Update payment status to success after delay
        await _updatePaymentStatus(transactionId);
        emit(PaymentSuccess(
            transactionId:
                transactionId)); // Pass transactionId to success state
      }
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _savePaymentData(
    List<Product> products,
    Map<String, int> quantities,
    String paymentMethod, {
    required String transactionId,
    required DateTime paymentDate,
    required String status,
  }) async {
    final paymentData = {
      'date': paymentDate,
      'products': products
          .where((p) =>
              quantities[p.id] != null &&
              quantities[p.id]! >
                  0) // Filter out products with null or zero quantities
          .map((p) => {
                'name': p.name,
                'quantity': quantities[p.id],
                'price': p.price,
              })
          .toList(),
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
    };

    await _firestore.collection('payments').add(paymentData);
  }


  Future<void> _updatePaymentStatus(
    String transactionId,
  ) async {
    // Retrieve the latest payment document with the specific transaction ID
    final querySnapshot = await _firestore
        .collection('payments')
        .where('transactionId', isEqualTo: transactionId)
        .orderBy('date', descending: true)
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
