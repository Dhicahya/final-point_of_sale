import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_sanber/models/report_mode.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Report>> getReports() async {
    final snapshot = await _firestore.collection('payments').get();
    return snapshot.docs.map((doc) => Report.fromDocument(doc)).toList();
  }
}
