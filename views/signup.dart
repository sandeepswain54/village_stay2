import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/model/global.dart';

class Signup extends StatefulWidget {
  final String userType;  // Add this line to accept userType
  
  const Signup({super.key, required this.userType});  // Modify constructor

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _FirstNameTextEditingController = TextEditingController();
  TextEditingController _LastNameTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? imageFileofUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
             colors: [Color(0xFFC9DEC8), Color(0xFF5C815E)],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          // Modify title to show user type
          "Signup as ${widget.userType}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
           colors: [Color(0xFFC9DEC8), Color(0xFF5C815E)],
            begin: FractionalOffset(0, 0),
            end: FractionalOffset(1, 0),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Image.asset(
                "assets/logo123.png",
                width: 280,
                height: 280,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                // Customize the message based on user type
                widget.userType == "Provider" 
                  ? "Tell us about your service" 
                  : "Tell us about yourself",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Add a field for service type if user is a provider
                    if (widget.userType == "Provider")
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 18),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Service Type"),
                          style: TextStyle(fontSize: 24),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter your service type";
                            }
                            return null;
                          },
                        ),
                      ),
                    
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 18),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "First Name",),
                        style: TextStyle(fontSize: 24,color: Colors.white),
                        controller: _FirstNameTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Last Name"),
                        style: TextStyle(fontSize: 24,color: Colors.white),
                        controller: _LastNameTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter your Last name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 18),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Email"),
                        style: TextStyle(fontSize: 24),
                        controller: _emailTextEditingController,
                        validator: (valueEmail) {
                          if (!valueEmail!.contains("@")) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 18),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Password"),
                        style: TextStyle(fontSize: 24),
                        controller: _passwordTextEditingController,
                        validator: (valuePassword) {
                          if (valuePassword!.length < 5) {
                            return "Password must be at least 6 or more characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "City"),
                        style: TextStyle(fontSize: 24),
                        controller: _cityTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter your City Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "State"),
                        style: TextStyle(fontSize: 24),
                        controller: _countryTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter your Country Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.userType == "Provider" 
                            ? "Service Description" 
                            : "Bio",
                        ),
                        style: TextStyle(fontSize: 24),
                        controller: _bioTextEditingController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return widget.userType == "Provider"
                              ? "Please enter your service description"
                              : "Please enter your Bio";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
           Padding(
  padding: const EdgeInsets.only(top: 38),
  child: MaterialButton(
    onPressed: () async {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        imageFileofUser = File(imageFile.path);
        setState(() {});
      }
    },
    child: imageFileofUser == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.black, // High contrast
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Tap to Add your Profile Pic",
                style: TextStyle(
                  color: Colors.white, // Visible on gradient
                  fontSize: 16,
                ),
              ),
            ],
          )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.width / 5,
                      child: CircleAvatar(
                        backgroundImage: FileImage(imageFileofUser!),
                        radius: MediaQuery.of(context).size.width / 5,
                      ),
                ),
  ),
          ),
        
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () {
                  if(!_formKey.currentState!.validate() || imageFileofUser == null) {
                    
Get.snackbar("Field Missing", " Please fill out complete signin form");
return;

                    
                  }

                  if(_emailTextEditingController.text.isEmpty && _passwordTextEditingController.text.isEmpty){
                                        
                 Get.snackbar("Field Missing", " Please fill out complete signin form");
                    return;
                  }

userViewModel.signup(
  email: _emailTextEditingController.text.trim(),
  password: _passwordTextEditingController.text.trim(),
  firstName: _FirstNameTextEditingController.text.trim(),
  lastName: _LastNameTextEditingController.text.trim(),
  city: _cityTextEditingController.text.trim(),
  country: _countryTextEditingController.text.trim(),
  bio: _bioTextEditingController.text.trim(),
  profileImage: imageFileofUser!,
  isHost: widget.userType == "Provider",  // Host if Provider
  serviceType: widget.userType == "Provider" ? "Your service type" : null,
);

                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: Text(
                  "Sign Up as ${widget.userType}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}