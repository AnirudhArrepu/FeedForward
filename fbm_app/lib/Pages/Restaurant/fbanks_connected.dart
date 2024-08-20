import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Styles/BgColor.dart';

class FB_Connected extends StatefulWidget {
  const FB_Connected({super.key});

  @override
  State<FB_Connected> createState() => _FB_ConnectedState();
}

class _FB_ConnectedState extends State<FB_Connected> {
  Future<List<Map<String, dynamic>>> getFoodbankdetails(String username) async {
    QuerySnapshot donationsnap = await FirebaseFirestore.instance
        .collection("donations")
        .where('username', isEqualTo: username)
        .get();
    List<String> foodbanknames =
        donationsnap.docs.map((doc) => doc['foodbank'] as String).toList();
    List<Map<String, dynamic>> FoodBankDetails = [];
    for (String foodbank in foodbanknames) {
      QuerySnapshot foodBanksnap = await FirebaseFirestore.instance
          .collection('foodbank')
          .where('name', isEqualTo: foodbank)
          .get();

      if (foodBanksnap.docs.isNotEmpty) {
        FoodBankDetails.add(foodBanksnap.docs.first.data() as Map<String, dynamic>);
      }
    }
    return FoodBankDetails;
  }

  @override
  Widget build(BuildContext context) {
    String currentUsername = DataClass.username;

    return Scaffold(
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        title: const Text(
          "Food Banks",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getFoodbankdetails(currentUsername),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (snapshot.hasError) {
              return Stack(
                children: [
                  const Center(child: Text("Error fetching data")),
                  _buildBottomButton(),
                ],
              );
            }
        
            final foodBanks = snapshot.data ?? [];
        
            return Stack(
              children: [
                if (foodBanks.isEmpty)
                  const Center(child: Text("No Food Banks Found")),
                if (foodBanks.isNotEmpty)
                  ListView.builder(
                    itemCount: foodBanks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final foodBank = foodBanks[index];
                      return ListTile(
                        leading: Text(
                          'FB${index + 1}', // Start numbering from 1
                          style: const TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: TextEditingController(
                                  text: foodBank['name'] ?? 'Food Bank Name'),
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: TextEditingController(
                                  text: foodBank['contactinfo'].toString() ?? 'Contact Info'),
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: TextEditingController(
                                  text: foodBank['address'].toString() ?? 'Foodbank Address'),
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                _buildBottomButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: butt(
          icon: Icon(Icons.add),
          routeName: "/outlets",
          text: "",
        ),
      ),
    );
  }
}
