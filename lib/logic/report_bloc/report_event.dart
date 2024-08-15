// report_event.dart
part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchReport extends ReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minPrice;
  final double? maxPrice;

  const FetchReport({
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [startDate, endDate, minPrice, maxPrice];
}
