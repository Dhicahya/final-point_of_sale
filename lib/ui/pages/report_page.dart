import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject_sanber/logic/report_bloc/report_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
            style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
          ),
          backgroundColor: blueColor,
          iconTheme: IconThemeData(color: whiteColor),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildFilterForm(context),
                const SizedBox(height: 16.0),
                Expanded(
                  child: BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      if (state is ReportLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ReportLoaded) {
                        return ListView.builder(
                          itemCount: state.reports.length,
                          itemBuilder: (context, index) {
                            final report = state.reports[index];
                            final date =
                                (report['date'] as Timestamp?)?.toDate() ??
                                    DateTime.now();
                            final products =
                                (report['products'] as List<dynamic>?)
                                        ?.map((product) =>
                                            product as Map<String, dynamic>)
                                        .toList() ??
                                    [];

                            // Calculate the total price from products
                            final totalPrice = products.fold<double>(
                              0.0,
                              (sum, product) {
                                final price =
                                    (product['price'] as num?)?.toDouble() ??
                                        0.0;
                                final quantity =
                                    (product['quantity'] as int?) ?? 0;
                                return sum + (price * quantity);
                              },
                            );

                            return Card(
                              color: whiteColor,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Transaction ID: ${report['transactionId']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                                    ),
                                    Text(
                                      'Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
                                    ),
                                    Text(
                                      'Payment Method: ${report['paymentMethod']}',
                                    ),
                                    Text(
                                      'Status: ${report['status']}',
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Products:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4.0),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: products.map((product) {
                                          final name =
                                              product['name'] as String?;
                                          final quantity =
                                              product['quantity'] as int?;
                                          final price =
                                              product['price'] as num?;
                                          return Text(
                                            '${name ?? 'Unknown Product'} - Quantity: ${quantity ?? 0}, Price: \Rp ${price?.toDouble().toStringAsFixed(2) ?? '0.00'}',
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is ReportFailure) {
                        return Center(child: Text('Error: ${state.error}'));
                      }
                      return Center(child: Text('No data available'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFilterForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Date Range Filter
        Text(
          'Filter by Date Range',
          style: blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildDateTextField(
                controller: _startDateController,
                labelText: 'Start Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildDateTextField(
                controller: _endDateController,
                labelText: 'End Date (YYYY-MM-DD)',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Price Range Filter
        Text(
          'Filter by Price Range',
          style: blackColorStyle.copyWith(fontSize: 18, fontWeight: bold),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildPriceTextField(
                controller: _minPriceController,
                labelText: 'Minimum Price',
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildPriceTextField(
                controller: _maxPriceController,
                labelText: 'Maximum Price',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        // Apply Filters Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              _fetchReport(context);
            },
            child: Text(
              'Apply Filters',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _buildPriceTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _fetchReport(BuildContext context) {
    final startDate = _parseDate(_startDateController.text);
    final endDate = _parseDate(_endDateController.text);
    final minPrice = _parseDouble(_minPriceController.text);
    final maxPrice = _parseDouble(_maxPriceController.text);

    context.read<ReportBloc>().add(
          FetchReport(
            startDate: startDate,
            endDate: endDate,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
        );
  }

  DateTime? _parseDate(String date) {
    if (date.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(date);
    } catch (e) {
      return null;
    }
  }

  double? _parseDouble(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }
}
