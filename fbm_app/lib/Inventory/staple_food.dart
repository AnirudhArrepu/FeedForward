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

      for (var donationDoc in donationsSnapshot.docs) {
        QuerySnapshot stapleFoodSnapshot = await donationDoc.reference
            .collection('Staple Food')
            .orderBy('expiryDate')
            .get();

        for (var stapleFoodDoc in stapleFoodSnapshot.docs) {
          allStapleFoodItems.add(stapleFoodDoc.data() as Map<String, dynamic>);
        }
      }
      setState(() {
        stapleFoodItems = allStapleFoodItems;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
        hasError = true;
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
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : hasError
                ? const Center(
                    child: Text("Error fetching data"),
                  )
                : stapleFoodItems.isEmpty
                    ? const Center(
                        child: Text("No staple food items found"),
                      )
                    : ListView.builder(
                        itemCount: stapleFoodItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = stapleFoodItems[index];
                          final itemName = item['itemName'] ?? 'Unknown Item';
                          final quantity =
                              item['quantity'] ?? 'Unknown Quantity';
                          final Timestamp expiryTimestamp =
                              item['expiryDate'] ?? Timestamp.now();
                          final expiryDate = expiryTimestamp.toDate();
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
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
                                    'Item: $itemName',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Quantity: $quantity'),
                                  const SizedBox(height: 5),
                                  Text(
                                      'Expiry Date: ${expiryDate.toLocal().toString().split(' ')[0]}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
