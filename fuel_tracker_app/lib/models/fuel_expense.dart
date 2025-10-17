class FuelExpense {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double odometer;
  final double unitPrice;
  final double liters;
  final double totalPrice;

  FuelExpense({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.odometer,
    required this.unitPrice,
    required this.liters,
    required this.totalPrice,
  });
}