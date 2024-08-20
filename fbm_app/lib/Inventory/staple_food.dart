import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/classes/data_class.dart';

class StapleFood extends StatefulWidget {
  const StapleFood({super.key});

  @override
  _StapleFoodState createState() => _StapleFoodState();
}

class _StapleFoodState extends State<StapleFood> {
  List<Map<String, dynamic>> stapleFoodItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchStapleFoodData();
  }
  
  Future<void> _fetchStapleFoodData() async {
    try {
      String foobankName = DataClass.foodbank;
      String userName = DataClass.username;
      QuerySnapshot donationsSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('foodbank', isEqualTo: foobankName)
          .get();
      List<Map<String, dynamic>> allStapleFoodItems = [];

      // Loop through each document in the donations collection

      for (var donationDoc in donationsSnapshot.docs) {
        // Query the staplefood subcollection under each donation document
        QuerySnapshot stapleFoodSnapshot = await donationDoc.reference
            .collection('Staple Food') // Access the staplefood subcollection
            .orderBy('expiryDate') // Order by expiryDate in ascending order
            .get(); // Execute the query and get the documents

        // Add each item from the staplefood subcollection to the temporary list
        for (var stapleFoodDoc in stapleFoodSnapshot.docs) {
          allStapleFoodItems.add(stapleFoodDoc.data() as Map<String, dynamic>);
        }
      }
      setState(() {
        stapleFoodItems =
            allStapleFoodItems; // Assign the fetched items to the state
        isLoading =
            false; // Set loading to false since the data has been fetched
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false; // Stop showing the loading spinner
        hasError = true; // Set error flag to true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.titleColor(),
        title: const Text(
          "Staple Food",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(235, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show loading spinner while data is being fetched
            )
          : hasError
              ? const Center(
                  child: Text(
                      "Error fetching data"), // Show error message if there is an error
                )
              : stapleFoodItems.isEmpty
                  ? const Center(
                      child: Text(
                          "No staple food items found"), // Show message if no data is found
                    )
                  : ListView.builder(
                      itemCount: stapleFoodItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = stapleFoodItems[index];
                        final itemName = item['itemName'] ?? 'Unknown Item';
                        final quantity = item['quantity'] ?? 'Unknown Quantity';
                        final Timestamp expiryTimestamp =
                            item['expiryDate'] ?? Timestamp.now();
                        final expiryDate = expiryTimestamp.toDate();
                        return Card(
                          // Create a card for each item
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0, // Vertical margin between cards
                            horizontal: 16.0, // Horizontal margin between cards
                          ),
                          child: ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item: $itemName', // Display the item name
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight
                                          .bold), // Bold font for item name
                                ),
                                const SizedBox(
                                    height: 5), // Add some vertical spacing
                                Text(
                                    'Quantity: $quantity'), // Display the quantity
                                const SizedBox(
                                    height: 5), // Add some vertical spacing
                                Text(
                                    'Expiry Date: ${expiryDate.toLocal().toString().split(' ')[0]}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
