import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:fbm_app/classes/data_class.dart';

class CreateFoodBank extends StatefulWidget {
  @override
  _CreateFoodBank createState() => _CreateFoodBank();
}

class _CreateFoodBank extends State<CreateFoodBank> {
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

  void submit() {}
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
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _foodBankNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Food Bank Name',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _contactInfoController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
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
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _cityNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'City Name',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _addressController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: clearButton,
                    child: Text('Clear All'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DataClass.addUsername(DataClass.username);
                      await _saveUserData(
                          _foodBankNameController.text,
                          _cityNameController.text,
                          _addressController.text,
                          int.parse(_contactInfoController.text));

                      // Show a Snackbar to confirm data submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data saved successfully')),
                      );

                      // Clear the input fields after submission
                      _foodBankNameController.clear();
                      _contactInfoController.clear();
                      _cityNameController.clear();
                      _addressController.clear();
                    },
                    child: Text(
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
