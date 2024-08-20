import 'dart:convert';

import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:http/http.dart' as http;

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

  static const String _apiKey = '271e15cf1a004fe0933d56e6a85b345b';
  static const String _baseUrl = 'https://api.opencagedata.com/geocode/v1/json';

  Future<GeoPoint> getGeoCode(String cityName) async {
    final Uri url = Uri.parse('$_baseUrl?q=$cityName&key=$_apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'].isNotEmpty) {
          final lat = data['results'][0]['geometry']['lat'];
          final lng = data['results'][0]['geometry']['lng'];
          return GeoPoint(lat, lng);
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return GeoPoint(0, 0);
  }

  Future<void> _saveUserData(
      String name, String cityname, String address, int contactinfo) async {
    try {
      await _firestore.collection('foodbank').add({
        'name': name,
        'username': DataClass.username,
        'contactinfo': contactinfo,
        'address': address,
        'location': await getGeoCode(cityname),
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
                      await _saveUserData(
                          _foodBankNameController.text,
                          _cityNameController.text,
                          _addressController.text,
                          int.parse(_contactInfoController.text));
                      DataClass.addUsername(DataClass.username);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Data saved successfully')),
                      );
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
