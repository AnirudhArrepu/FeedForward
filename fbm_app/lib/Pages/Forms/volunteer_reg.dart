import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerForm extends StatefulWidget {
  @override
  _VolunteerFormState createState() => _VolunteerFormState();
}

class _VolunteerFormState extends State<VolunteerForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _foodbankController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveUserData(
      String username, int hours) async {
    try {
      await _firestore.collection('volunteers').add({
        'username': username,
        'hours': hours,
        'foodbank': DataClass.foodbank,
      });
      print("Data saved successfully");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        title: const Text(
          'Volunteer Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter the username',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 25),
                TextField(
                    controller: _hoursController,
                    decoration: InputDecoration(
                      labelText: 'Number of hours worked',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    // Parse the hours worked input to an integer
                    int hoursWorked = int.tryParse(_hoursController.text) ?? 0;
        
                    // Call the function to save the data to Firestore
                    await _saveUserData(_userNameController.text, hoursWorked);
        
                    // Show a Snackbar to confirm data submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data saved successfully')),
                    );
        
                    // Clear the input fields after submission
                    _userNameController.clear();
                    _hoursController.clear();
                  },
                  child: Text(
                    "SUBMIT",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
