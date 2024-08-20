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
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, int>> Donations = [];

    void loadUserDonations() async {
      CollectionReference donations =
          FirebaseFirestore.instance.collection('donations');
      QuerySnapshot querySnapshot = await donations.get();

      for (var doc in querySnapshot.docs) {
        if (doc["username"] == DataClass.username) {
          String foodbank_name = doc['foodbank'];
          int points = LeaderboardClass.userPointsDonations[doc['username']]!;
          Donations.add({foodbank_name: points});
        }
      }
    }

    @override
    void initState() {
      super.initState();
      LeaderboardClass.allocatePointsDonations();
      loadUserDonations();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text_Theme.text_size("MY DONATIONS", 20),
        leading: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 550,
                child: ListView.builder(
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
    );
  }
}
