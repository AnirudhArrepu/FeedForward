import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Button/aligned_button.dart';
// ignore: unused_import
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:fbm_app/classes/leaderboard_class.dart';
import 'package:flutter/material.dart';

class Donations extends StatefulWidget {
  const Donations({super.key});

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  final List<Map<String, int>> Donations = [];

  @override
  void initState() {
    super.initState();
    loadUserDonations();
  }

  void loadUserDonations() async {
    // await LeaderboardClass.allocatePointsDonations();
    CollectionReference donations =
        FirebaseFirestore.instance.collection('donations');
    QuerySnapshot querySnapshot = await donations.get();

    for (var doc in querySnapshot.docs) {
      print(doc);
      if (doc["username"] == DataClass.username) {
        String foodbank_name = doc['foodbank'];
        int points = await LeaderboardClass.calculatePointsDonations(doc);
        LeaderboardClass.userPointsDonations[doc['username']]!;
        Donations.add({foodbank_name: points});
      }
    }
    print('done');
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text_Theme.text_size("MY DONATIONS", 20),
      ),
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 550,
                  child: Donations.length == 0
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: Donations.length,
                          itemBuilder: (context, index) {
                            Map<String, int> donation = Donations[index];
                            return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                child: ListTile(
                                  title: Text_Theme.text_size(
                                      'Foodbank: ${donation.keys.first}', 20),
                                  subtitle: Text_Theme.text_size(
                                      'Points: ${donation.values.first}', 15),
                                ));
                          })),
              Container(
                height: 50,
                child: GestureDetector(onDoubleTap: () {
                  Navigator.pushNamed(context, '/emergency');
                }),
              ),
              SizedBox(
                height: 100,
              ),
              AlignedButton(
                text: "",
                routeName: "/outlets",
                icon: Icon(Icons.add),
                align: Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
