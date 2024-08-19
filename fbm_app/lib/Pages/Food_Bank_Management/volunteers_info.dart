import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:flutter/material.dart';

class volunteers_info extends StatelessWidget {
  volunteers_info({super.key});
  String foodbank = DataClass.foodbank;
  // Fetch foodbank name based on the GeoPoint location
  Future<String?> _getFoodBankName() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('foodbank')
          .where('name', isEqualTo: foodbank) // Correct syntax
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final foodbankData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return foodbankData[
            'name']; // Assuming the foodbank document has a 'name' field
      } else {
        return null; // No matching foodbank found
      }
    } catch (e) {
      print("Error fetching foodbank data: $e");
      return null; // Return null in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Assign a temporary target location (GeoPoint)
    final GeoPoint targetLocation =
        GeoPoint(26.2967719, 73.0351433); // Replace with your target location

    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: butt(
            icon: Icon(Icons.add),
            routeName: "/vform",
            text: "",
          ),
        ),
      ),
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        backgroundColor: AppTheme.titleColor(),
        title: const Text(
          "VOLUNTEER INFO",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getFoodBankName(), // Fetch the foodbank name based on location
        builder: (context, foodbankSnapshot) {
          if (foodbankSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading spinner while fetching foodbank data
          }

          if (foodbankSnapshot.hasError || !foodbankSnapshot.hasData) {
            return const Center(
                child: Text(
                    "Error or no foodbank found for the location")); // Show error if fetching foodbank data fails
          }

          final String? foodbankName = foodbankSnapshot.data;

          if (foodbankName == null) {
            return const Center(
                child: Text(
                    "No foodbank found for the specified location")); // Show message if no foodbank matches the location
          }

          // If the foodbank name is retrieved, fetch the volunteers for that foodbank
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('volunteers')
                .where('foodbank',
                    isEqualTo:
                        foodbankName) // Filter volunteers by the specific foodbank name
                .get(),
            builder: (context, volunteerSnapshot) {
              if (volunteerSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show a loading spinner while fetching volunteer data
              }

              if (volunteerSnapshot.hasError) {
                return const Center(
                    child: Text(
                        "Error fetching volunteer data")); // Show error if fetching volunteer data fails
              }

              if (!volunteerSnapshot.hasData ||
                  volunteerSnapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                  "No volunteers found for the specified foodbank",
                  style: TextStyle(color: Colors.white),
                )); // Show message if no volunteers match the foodbank
              }

              // Get the list of volunteer documents from the snapshot
              final List<DocumentSnapshot> volunteers =
                  volunteerSnapshot.data!.docs;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 800,
                      child: ListView.builder(
                        itemCount: volunteers.length,
                        itemBuilder: (BuildContext context, int index) {
                          final volunteerData =
                              volunteers[index].data() as Map<String, dynamic>;
                          final serial = 'V${index + 1}';
                          final foodbank =
                              volunteerData['foodbank'] ?? 'unknown';
                          final hours = volunteerData['hours'] ?? 0;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 16.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text_Theme.text_size(serial, 20),
                                  Text_Theme.text_size(
                                      'Food Bank Name: $foodbank', 20),
                                ],
                              ),
                              subtitle: Text_Theme.text_size(
                                  'No of Hours Volunteered: $hours', 20),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
