import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellerOnboardingScreen extends StatefulWidget {
  const SellerOnboardingScreen({super.key});

  @override
  _SellerOnboardingScreenState createState() => _SellerOnboardingScreenState();
}

class _SellerOnboardingScreenState extends State<SellerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Controllers
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController price1Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  final TextEditingController price2Controller = TextEditingController();
  final TextEditingController product3Controller = TextEditingController();
  final TextEditingController price3Controller = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  
  String gstOption = "I have GSTIN";
  bool termsAccepted = false;
  
  // For image uploads
  File? _dressImage;
  File? _bagImage;
  File? _carryBagImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> handmadeCategories = [
    "Bags", "Jewelry", "Pottery", "Handmade Clothing", "Artwork",
    "Wood Crafts", "Candles", "Soap", "Home Decor", "Toys", "Stationery",
  ];

  Future<void> _pickImage(int productNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (productNumber == 1) {
          _dressImage = File(pickedFile.path);
        } else if (productNumber == 2) {
          _bagImage = File(pickedFile.path);
        } else if (productNumber == 3) {
          _carryBagImage = File(pickedFile.path);
        }
      });
    }
  }

  void _nextPage() {
    if (_validateCurrentStep()) {
      if (_currentPage < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300), 
          curve: Curves.ease
        );
      } else {
        _registerSeller();
      }
    }
  }

  bool _validateCurrentStep() {
    if (_currentPage == 0) {
      if (businessNameController.text.trim().isEmpty) {
        _showError("Please enter a business name.");
        return false;
      }
    } else if (_currentPage == 1) {
      if (product1Controller.text.trim().isEmpty &&
          product2Controller.text.trim().isEmpty &&
          product3Controller.text.trim().isEmpty) {
        _showError("Please enter at least one product name.");
        return false;
      }
    } else if (_currentPage == 2) {
      if (gstOption == "I have GSTIN" && gstController.text.trim().isEmpty) {
        _showError("Please enter GST number.");
        return false;
      } else if (gstOption != "I have GSTIN" &&
          panController.text.trim().isEmpty) {
        _showError("Please enter PAN number.");
        return false;
      }
      if (!termsAccepted) {
        _showError("Please accept the terms and privacy policy.");
        return false;
      }
    } else if (_currentPage == 3) {
      // Validate at least one product has both name and price
      if (product1Controller.text.trim().isNotEmpty && price1Controller.text.trim().isEmpty) {
        _showError("Please enter price for Product 1");
        return false;
      }
      if (product2Controller.text.trim().isNotEmpty && price2Controller.text.trim().isEmpty) {
        _showError("Please enter price for Product 2");
        return false;
      }
      if (product3Controller.text.trim().isNotEmpty && price3Controller.text.trim().isEmpty) {
        _showError("Please enter price for Product 3");
        return false;
      }
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _registerSeller() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError("User not authenticated");
        return;
      }

      // Prepare products list with image flags
      List<Map<String, dynamic>> products = [];
      if (product1Controller.text.isNotEmpty) {
        products.add({
          'name': product1Controller.text,
          'price': price1Controller.text,
          'type': 'dress',
          'hasImage': _dressImage != null,
        });
      }
      if (product2Controller.text.isNotEmpty) {
        products.add({
          'name': product2Controller.text,
          'price': price2Controller.text,
          'type': 'bag',
          'hasImage': _bagImage != null,
        });
      }
      if (product3Controller.text.isNotEmpty) {
        products.add({
          'name': product3Controller.text,
          'price': price3Controller.text,
          'type': 'carry_bag',
          'hasImage': _carryBagImage != null,
        });
      }

      // Create seller data
      Map<String, dynamic> sellerData = {
        'businessName': businessNameController.text,
        'userId': user.uid,
        'email': user.email,
        'gstOption': gstOption,
        'gstNumber': gstOption == "I have GSTIN" ? gstController.text : null,
        'panNumber': gstOption != "I have GSTIN" ? panController.text : null,
        'products': products,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      // Add to Firestore
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .set(sellerData);

      // Show success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SellerDashboardScreen(),
        ),
      );
    } catch (e) {
      _showError("Failed to register: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Sell on IndianArt")),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBusinessNameStep(),
                _buildProductStep(),
                _buildGstinStep(),
                _buildProductDetailsStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return CircleAvatar(
            radius: 15,
            backgroundColor:
                index <= _currentPage ? Colors.green : Colors.grey[300],
            child: Text("${index + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          );
        }),
      ),
    );
  }

  Widget _buildBusinessNameStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Business Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
              "Hi User, start your journey on India's largest online Marketplace for FREE"),
          const SizedBox(height: 20),
          TextField(
            controller: businessNameController,
            decoration: const InputDecoration(
              labelText: "Business/Company/Shop Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8)),
            child: const Text(
              "Note: Avoid these mistakes\n• Amit ❌ → Amit Stores ✅\n• Furniture ❌ → Suresh Furnitures ✅\n• Sunil Patel ❌ → Sunil Patel Stores ✅\n\nPlease do not enter your personal name as your business name.",
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Add 3 products you wish to sell, you can add more later"),
          const SizedBox(height: 20),
          _buildProductAutocomplete("1st product name", product1Controller),
          const SizedBox(height: 10),
          _buildProductAutocomplete("2nd product name", product2Controller),
          const SizedBox(height: 10),
          _buildProductAutocomplete("3rd product name", product3Controller),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Text(
                  "Add photos Attract 2X buyers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Make More Sales!",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          if (product1Controller.text.isNotEmpty) ...[
            _buildProductPhotoCard(
              "Dress",
              product1Controller.text,
              price1Controller,
              _dressImage,
              () => _pickImage(1),
            ),
            const SizedBox(height: 20),
          ],
          
          if (product2Controller.text.isNotEmpty) ...[
            _buildProductPhotoCard(
              "Bag",
              product2Controller.text,
              price2Controller,
              _bagImage,
              () => _pickImage(2),
            ),
            const SizedBox(height: 20),
          ],
          
          if (product3Controller.text.isNotEmpty) ...[
            _buildProductPhotoCard(
              "Carry Bags",
              product3Controller.text,
              price3Controller,
              _carryBagImage,
              () => _pickImage(3),
            ),
            const SizedBox(height: 20),
          ],
          
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Complete Registration"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPhotoCard(
    String label,
    String productName,
    TextEditingController priceController,
    File? imageFile,
    VoidCallback onAddPhotoPressed,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              productName,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price (INR)",
                border: OutlineInputBorder(),
                prefixText: "₹ ",
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: onAddPhotoPressed,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("ADD PHOTO", style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : Image.file(imageFile, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductAutocomplete(String label, TextEditingController controller) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return handmadeCategories.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text = controller.text;
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildGstinStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add GSTIN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Add GST to get double orders. 100% Safe & Secure."),
          const SizedBox(height: 20),

          if (gstOption == "I have GSTIN")
            TextField(
              controller: gstController,
              decoration: const InputDecoration(
                labelText: "Enter your GST Details",
                hintText: "Eg: 22A*********A1Z5",
                border: OutlineInputBorder(),
              ),
            )
          else
            TextField(
              controller: panController,
              decoration: const InputDecoration(
                labelText: "Enter your PAN Details",
                hintText: "Eg: ABCDE1234F",
                border: OutlineInputBorder(),
              ),
            ),
          const SizedBox(height: 15),
          Column(
            children: [
              RadioListTile(
                value: "I have GSTIN",
                groupValue: gstOption,
                onChanged: (val) => setState(() => gstOption = val.toString()),
                title: const Text("I have GSTIN"),
              ),
              RadioListTile(
                value: "Exempted",
                groupValue: gstOption,
                onChanged: (val) => setState(() => gstOption = val.toString()),
                title: const Text("Exempted"),
              ),
              RadioListTile(
                value: "Don't remember",
                groupValue: gstOption,
                onChanged: (val) => setState(() => gstOption = val.toString()),
                title: const Text("Don't remember"),
              ),
              RadioListTile(
                value: "Don't have it",
                groupValue: gstOption,
                onChanged: (val) => setState(() => gstOption = val.toString()),
                title: const Text("Don't have it"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CheckboxListTile(
            value: termsAccepted,
            onChanged: (val) => setState(() => termsAccepted = val!),
            title: const Text("I accept all the terms and privacy policy"),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not authenticated")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No seller data found"));
          }

          final sellerData = snapshot.data!.data() as Map<String, dynamic>;
          final products = List<Map<String, dynamic>>.from(sellerData['products'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerData['businessName'] ?? 'No Business Name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Status: ${sellerData['status'] ?? 'pending'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: sellerData['status'] == 'approved' 
                        ? Colors.green 
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Products:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Price: ₹${product['price'] ?? '0'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Type: ${product['type']?.replaceAll('_', ' ') ?? ''}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (product['hasImage'] == true)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Icon(Icons.image, color: Colors.green),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}