import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Pages/Forms/donationform.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Button/button.dart';

class Outlets extends StatefulWidget {
  const Outlets({super.key});

  @override
  State<Outlets> createState() => _OutletsState();
}

class _OutletsState extends State<Outlets> {
  List<String> outlets = [];

  @override
  void initState() {
    super.initState();
    outlets = DataClass.foodbankWithoutLocation;
    loadFoodBankDetails();
  }

  Future<void> loadFoodBankDetails() async {
    CollectionReference foodbankcollection =
        FirebaseFirestore.instance.collection('foodbank');

    QuerySnapshot queryfoodbank = await foodbankcollection.get();

    for (var doc in queryfoodbank.docs) {
      String name = doc['name'];
      // Add logic here if you need to filter specific food banks
      if (!outlets.contains(name)) {
        setState(() {
          outlets.add(name);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text(
          "OUTLETS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 800,
              child: ListView.builder(
                itemCount: outlets.length,
                itemBuilder: (context, index) {
                  final outlet = outlets[index];
                  return GestureDetector(
                    onDoubleTap: () {
                      Navigator.pushNamed(context, '/emergency');
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text_Theme.text_size(outlet, 25),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton.extended(
                                label: Text_Theme.text_white("Donate"),
                                backgroundColor: AppTheme.secondaryColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => DonationForm(
                                        foodbank: outlet,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.handshake),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
