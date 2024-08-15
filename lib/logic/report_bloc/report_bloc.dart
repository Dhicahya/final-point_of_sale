// report_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReportBloc() : super(ReportInitial()) {
    on<FetchReport>(_onFetchReport);
  }

  Future<void> _onFetchReport(
    FetchReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      Query query = _firestore.collection('payments');

      if (event.startDate != null && event.endDate != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: event.startDate)
            .where('date', isLessThanOrEqualTo: event.endDate);
      }

      if (event.minPrice != null) {
        query =
            query.where('totalPrice', isGreaterThanOrEqualTo: event.minPrice);
      }

      if (event.maxPrice != null) {
        query = query.where('totalPrice', isLessThanOrEqualTo: event.maxPrice);
      }

      final querySnapshot = await query.get();
      final reports = querySnapshot.docs
          .map((doc) => doc.data()
              as Map<String, dynamic>) // Cast data to Map<String, dynamic>
          .toList();

      emit(ReportLoaded(reports: reports));
    } catch (e) {
      emit(ReportFailure(error: e.toString()));
    }
  }

}
