import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/classes/data_class.dart';

class CookedFood extends StatefulWidget {
  const CookedFood({super.key});

  @override
  _CookedFoodState createState() => _CookedFoodState();
}

class _CookedFoodState extends State<CookedFood> {
  List<Map<String, dynamic>> cookedFoodItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCookedFoodData();
  }

  Future<void> _fetchCookedFoodData() async {
    try {
      String foobankName = DataClass.foodbank;
      String userName = DataClass.username;
      QuerySnapshot donationsSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('foodbank', isEqualTo: foobankName)
          .get();

      List<Map<String, dynamic>> allCookedFoodItems = [];

      for (var donationDoc in donationsSnapshot.docs) {
        QuerySnapshot cookedFoodSnapshot = await donationDoc.reference
            .collection('cookedfood')
            .orderBy('expiryDate')
            .get();

        for (var cookedFoodDoc in cookedFoodSnapshot.docs) {
          allCookedFoodItems.add(cookedFoodDoc.data() as Map<String, dynamic>);
        }
      }
      setState(() {
        cookedFoodItems = allCookedFoodItems;
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
          "Cooked Food",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(235, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasError
              ? const Center(
                  child: Text("Error fetching data"),
                )
              : cookedFoodItems.isEmpty
                  ? const Center(
                      child: Text("No cooked food items found"),
                    )
                  : ListView.builder(
                      itemCount: cookedFoodItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = cookedFoodItems[index];
                        final itemName = item['itemName'] ?? 'Unknown Item';
                        final quantity = item['quantity'] ?? 'Unknown Quantity';
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
    );
  }
}
