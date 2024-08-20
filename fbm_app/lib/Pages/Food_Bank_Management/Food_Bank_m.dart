import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:flutter/material.dart';

class Food_Bank_Management extends StatefulWidget {
  const Food_Bank_Management({super.key});

  @override
  State<Food_Bank_Management> createState() => _Food_Bank_ManagementState();
}

class _Food_Bank_ManagementState extends State<Food_Bank_Management> {
  void loadData() async{
    String foodbank = DataClass.foodbank;
    CollectionReference foodbanks =
        FirebaseFirestore.instance.collection('foodbank');
    QuerySnapshot querySnapshot = await foodbanks.get();

    for(var doc in querySnapshot.docs){
      if(doc['name']==DataClass.foodbank){
        
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text(
          'Food Bank Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 32,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text_Theme.text_colored("FOOD BANK NAME", 30, Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text_Theme.text_field("FOOD BANK NAME", 20),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text_Theme.text_colored(
                  "FOOD BANK ADDRESS", 30, Colors.white),
            ),
            SizedBox(height: 5),
            Text_Theme.text_field("FOOD BANK ADDRESS", 20),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text_Theme.text_colored("CONTACT INFO", 30, Colors.white),
            ),
            SizedBox(height: 5),
            Text_Theme.text_field("CONTATC INFO", 20),
            SizedBox(
              height: 2,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              child: GestureDetector(onDoubleTap: () {
                Navigator.pushNamed(context, '/emergency');
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                ),
                butt(
                  text: "INVENTORY",
                  routeName: "/inventory",
                  icon: Icon(Icons.food_bank),
                ),
                SizedBox(
                  width: 10,
                ),
                butt(
                  text: "VOLUNTEERS",
                  routeName: "/v_info",
                  icon: Icon(Icons.favorite),
                ),
              ],
            ),
            butt(
              text: "RESTAURANTS",
              routeName: "/restaurants",
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
