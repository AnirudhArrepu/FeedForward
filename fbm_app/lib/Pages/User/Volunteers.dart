import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';

class Volunteers extends StatefulWidget {
  const Volunteers({super.key});

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends State<Volunteers> {
  final List<Map<String, String>> volunteers = [];

  @override
  void initState() {
    super.initState();
    getVolunteerInfo();
  }

  void getVolunteerInfo() async {
    CollectionReference volunteer =
        FirebaseFirestore.instance.collection('volunteers');
    QuerySnapshot querySnapshot = await volunteer.get();

    for (var doc in querySnapshot.docs) {
      String? name = doc['foodbank'];
      int? hours = doc['hours'];

      // Check if the data exists and is not null
      if (name != null && hours != null) {
        setState(() {
          volunteers.add({name: hours.toString()});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        title: Text(
          "VOLUNTEERS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 246, 244, 244),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (BuildContext context, int index) {
              final serial = 'V${index + 1}';
              final volun = volunteers[index];
              final foodbank_name = volun.keys.first;
              final hours = volun.values.first;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: ListTile(
                  title: Column(
                    children: [
                      Text_Theme.text_size(serial.toString(), 22),
                      Text_Theme.text_size(
                          "Food Bank Name: $foodbank_name", 22),
                    ],
                  ),
                  subtitle: Text_Theme.text_size("No of Hours: $hours", 22),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
