import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AddFuelExpenseScreen extends StatefulWidget {
  final String vehicleId;

  const AddFuelExpenseScreen({super.key, required this.vehicleId});

  @override
  State<AddFuelExpenseScreen> createState() => _AddFuelExpenseScreenState();
}

class _AddFuelExpenseScreenState extends State<AddFuelExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _litersController = TextEditingController();
  final _totalPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _unitPriceController.addListener(_calculateTotalPrice);
    _litersController.addListener(_calculateTotalPrice);
    _totalPriceController.addListener(_calculateLiters);
  }

  void _calculateTotalPrice() {
    final unitPrice = double.tryParse(_unitPriceController.text);
    final liters = double.tryParse(_litersController.text);
    if (unitPrice != null && liters != null) {
      final totalPrice = unitPrice * liters;
      _totalPriceController.removeListener(_calculateLiters);
      _totalPriceController.text = totalPrice.toStringAsFixed(2);
      _totalPriceController.addListener(_calculateLiters);
    }
  }

  void _calculateLiters() {
    final totalPrice = double.tryParse(_totalPriceController.text);
    final unitPrice = double.tryParse(_unitPriceController.text);
    if (totalPrice != null && unitPrice != null && unitPrice > 0) {
      final liters = totalPrice / unitPrice;
      _litersController.removeListener(_calculateTotalPrice);
      _litersController.text = liters.toStringAsFixed(2);
      _litersController.addListener(_calculateTotalPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fuel Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _odometerController,
                decoration: const InputDecoration(labelText: 'Odometer'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the odometer reading';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _litersController,
                decoration: const InputDecoration(labelText: 'Liters'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _totalPriceController,
                decoration: const InputDecoration(labelText: 'Total Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<FirebaseFirestore>(context, listen: false)
                        .collection('vehicles')
                        .doc(widget.vehicleId)
                        .collection('fuel_expenses')
                        .add({
                      'date': DateTime.now(),
                      'odometer': double.parse(_odometerController.text),
                      'unitPrice': double.parse(_unitPriceController.text),
                      'liters': double.parse(_litersController.text),
                      'totalPrice': double.parse(_totalPriceController.text),
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _unitPriceController.dispose();
    _litersController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }
}