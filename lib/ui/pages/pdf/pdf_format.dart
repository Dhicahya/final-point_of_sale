import 'package:finalproject_sanber/models/product_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> generatePdf({
  required String paymentMethod,
  required double totalPrice,
  required String transactionId,
  required DateTime paymentDate,
  required List<Product> products,
  required Map<String, int> quantities,
}) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Payment Success',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Payment Method: $paymentMethod',
              style: pw.TextStyle(fontSize: 16)),
          pw.Text('Transaction ID: $transactionId',
              style: pw.TextStyle(fontSize: 16)),
          pw.Text('Payment Date: ${paymentDate.toLocal().toString()}',
              style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 20),
          pw.Text('Order Details:',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...products
              .where((product) => quantities[product.id] != null)
              .map((product) {
            final quantity = quantities[product.id]!;
            final price = product.price * quantity;
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${product.name} x $quantity',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text('\Rp ${price.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16)),
              ],
            );
          }).toList(),
          pw.SizedBox(height: 20),
          pw.Text('Total Price: \Rp ${totalPrice.toStringAsFixed(2)}',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      );
    },
  ));

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/payment_summary.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
}
