import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExportService {
  Future<void> exportData(FirebaseFirestore firestore) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow([
      TextCellValue('Vehicle Name'),
      TextCellValue('Vehicle Make'),
      TextCellValue('Vehicle Model'),
      TextCellValue('Vehicle Year'),
      TextCellValue('Expense Type'),
      TextCellValue('Date'),
      TextCellValue('Odometer'),
      TextCellValue('Unit Price'),
      TextCellValue('Liters'),
      TextCellValue('Total Price'),
      TextCellValue('Maintenance/Other Details'),
    ]);

    final vehicles = await firestore.collection('vehicles').get();

    for (final vehicleDoc in vehicles.docs) {
      final vehicleData = vehicleDoc.data();
      final vehicleName = vehicleData['name'];
      final vehicleMake = vehicleData['make'];
      final vehicleModel = vehicleData['model'];
      final vehicleYear = vehicleData['year'];

      // Export fuel expenses
      final fuelExpenses = await vehicleDoc.reference.collection('fuel_expenses').get();
      for (final expenseDoc in fuelExpenses.docs) {
        final expenseData = expenseDoc.data();
        sheet.appendRow([
          TextCellValue(vehicleName),
          TextCellValue(vehicleMake),
          TextCellValue(vehicleModel),
          IntCellValue(vehicleYear),
          TextCellValue('Fuel'),
          TextCellValue(expenseData['date'].toDate().toString()),
          DoubleCellValue(expenseData['odometer']),
          DoubleCellValue(expenseData['unitPrice']),
          DoubleCellValue(expenseData['liters']),
          DoubleCellValue(expenseData['totalPrice']),
          TextCellValue(''),
        ]);
      }

      // We will add maintenance and other expenses here later
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/fuel_tracker_data.xlsx');
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }
  }
}