import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/model/posting_model.dart';
import 'package:service_app/views/host_home.dart';

class CreatePostingScreen extends StatefulWidget {
  const CreatePostingScreen({super.key, PostingModel? posting});

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _amenitiesController = TextEditingController();

  final List<String> _serviceTypes = [
    "Plumbing",
    "Electrical",
    "Cleaning",
    "Carpentry",
    "Painting",
    "Gardening",
    "Moving",
    "Handyman"
  ];

  late String _selectedServiceType;
  late Map<String, int> _beds;
  late Map<String, int> _bathrooms;
  List<String> _base64Images = [];

  @override
  void initState() {
    super.initState();
    _selectedServiceType = _serviceTypes.first;
    _beds = {"small": 0, "medium": 0, "large": 0};
    _bathrooms = {"full": 0, "half": 0};
  }

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        if (index < 0) {
          _base64Images.add(base64Image);
        } else {
          _base64Images[index] = base64Image;
        }
      });
    }
  }

  Future<void> _submitPosting() async {
    if (!_formKey.currentState!.validate()) return;
    if (_base64Images.isEmpty) {
      Get.snackbar("Error", "Please add at least one image");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseFirestore.instance.collection('service_listings').add({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'country': _countryController.text.trim(),
        'amenities': _amenitiesController.text.split(',').map((e) => e.trim()).toList(),
        'type': _selectedServiceType,
        'beds': _beds,
        'bathrooms': _bathrooms,
        'images': _base64Images,
        'host': AppConstants.currentUser.createUserFromContact(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();
      Get.snackbar("Success", "Service created successfully");
      Get.offAll(() => HostHomeScreen(Index: 1));
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Error", "Failed to save: ${e.toString()}");
    }
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Row(
      children: [
        Text("$label: "),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => onChanged(value - 1 < 0 ? 0 : value - 1),
        ),
        Text(value.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _base64Images.length + 1,
      itemBuilder: (context, index) {
        if (index == _base64Images.length) {
          return GestureDetector(
            onTap: () => _pickImage(-1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_a_photo, size: 40),
            ),
          );
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(_base64Images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => setState(() => _base64Images.removeAt(index)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _amenitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Service"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A6CF7), Color(0xFF82C3FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Listing Name"),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                items: _serviceTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) => setState(() => _selectedServiceType = value!),
                decoration: const InputDecoration(labelText: "Service Type"),
                validator: (value) => value == null ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price (\$/day)"),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "Required";
                  if (double.tryParse(value!) == null) return "Invalid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "City"),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: "Country"),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              const Text("Beds", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildCounter("Small", _beds["small"]!, (value) => setState(() => _beds["small"] = value)),
              _buildCounter("Medium", _beds["medium"]!, (value) => setState(() => _beds["medium"] = value)),
              _buildCounter("Large", _beds["large"]!, (value) => setState(() => _beds["large"] = value)),
              const SizedBox(height: 16),

              const Text("Bathrooms", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildCounter("Full", _bathrooms["full"]!, (value) => setState(() => _bathrooms["full"] = value)),
              _buildCounter("Half", _bathrooms["half"]!, (value) => setState(() => _bathrooms["half"] = value)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amenitiesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Your Experiences",
                  hintText: "WiFi, Parking, Kitchen, etc.",
                ),
                validator: (value) => value?.isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),

              const Text("Photos", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildImageGrid(),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: _submitPosting,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text("Create Service"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
