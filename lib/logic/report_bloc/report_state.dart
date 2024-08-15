// report_state.dart
part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;

  const ReportLoaded({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class ReportFailure extends ReportState {
  final String error;

  const ReportFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
