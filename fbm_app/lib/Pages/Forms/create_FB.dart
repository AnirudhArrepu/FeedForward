import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:fbm_app/classes/data_class.dart';

class CreateFoodBank extends StatefulWidget {
  @override
  State<CreateFoodBank> createState() => _CreateFoodBankState();
}

class _CreateFoodBankState extends State<CreateFoodBank> {
  final TextEditingController _foodBankNameController = TextEditingController();

  final TextEditingController _contactInfoController = TextEditingController();

  final TextEditingController _cityNameController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void clearButton() {
    _foodBankNameController.clear();
    _contactInfoController.clear();
    _cityNameController.clear();
    _addressController.clear();
  }

  Future<void> _saveUserData(
      String name, String cityname, String address, int contactinfo) async {
    try {
      await _firestore.collection('foodbank').add({
        'name': name,
        'username': DataClass.username,
        'contactinfo': contactinfo,
      });
      print("Data saved successfully");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        title: const Text(
          "Create Food Bank",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(235, 0, 0, 0),
          ),
        ),
        backgroundColor: AppTheme.titleColor(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _foodBankNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Food Bank Name',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _contactInfoController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Contact Info',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _cityNameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'City Name',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: clearButton,
                    child: const Text('Clear All'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Parse the hours worked input to an integer

                      // Call the function to save the data to Firestore
                      await _saveUserData(
                          _foodBankNameController.text,
                          _cityNameController.text,
                          _addressController.text,
                          int.parse(_contactInfoController.text));

                      // Show a Snackbar to confirm data submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data saved successfully')),
                      );

                      // Clear the input fields after submission
                      _foodBankNameController.clear();
                      _contactInfoController.clear();
                      _cityNameController.clear();
                      _addressController.clear();
                    },
                    child: const Text(
                      "SUBMIT",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
