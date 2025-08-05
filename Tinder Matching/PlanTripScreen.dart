import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'trip_model.dart';
import 'trip_data.dart';
import 'swipe_card_screen.dart';

class PlanTripScreen extends StatefulWidget {
  @override
  _PlanTripScreenState createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  DateTime? _startDate, _endDate;
  List<String> imagePaths = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 60);
    if (picked != null) {
      setState(() {
        imagePaths = picked.map((img) => img.path).toList();
      });
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        imagePaths.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select images')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final trip = TripModel(
      name: nameController.text.trim(),
      description: descController.text.trim(),
      budget: int.parse(budgetController.text.trim()),
      startDate: _startDate!,
      endDate: _endDate!,
      imagePaths: List<String>.from(imagePaths),
    );

    allTrips.add(trip);

    final List<TripModel> matchedTrips = allTrips.where((t) =>
        t != trip &&
        t.budget == trip.budget &&
        t.startDate == trip.startDate &&
        t.endDate == trip.endDate).toList();

    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      nameController.clear();
      descController.clear();
      budgetController.clear();
      imagePaths.clear();
      _startDate = null;
      _endDate = null;
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SwipeCardScreen(initialTrips: matchedTrips)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan Your VillageStay")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget (₹)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickDate(true),
                          icon: const Icon(Icons.date_range),
                          label: Text(_startDate == null
                              ? 'Start Date'
                              : _startDate!.toLocal().toString().split(' ')[0]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickDate(false),
                          icon: const Icon(Icons.date_range),
                          label: Text(_endDate == null
                              ? 'End Date'
                              : _endDate!.toLocal().toString().split(' ')[0]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pick Trip Images"),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: imagePaths
                        .map((p) => Image.file(
                              File(p),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit & Match"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
