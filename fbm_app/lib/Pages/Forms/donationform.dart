import 'package:fbm_app/Styles/BgColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/classes/data_class.dart';

class DonationForm extends StatefulWidget {
  final String foodbank;
  const DonationForm({super.key, required this.foodbank});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  static List<ItemDonationWidget> widgets = [];

  void addWidgets() {
    widgets.add(const ItemDonationWidget());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          title: const Text("Donation Form",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(235, 0, 0, 0))),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              //
              for (int i = 0; i < widgets.length; i++) widgets[i],
              //
              const Row(children: [
                SizedBox(height: 40, width: 135),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    label: Text_Theme.text_white(text),
                    backgroundColor: AppTheme.secondaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, routeName);
                    },
                    icon: icon,
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  label: Text(""),
                  icon: Icon(Icons.add),
                  onPressed: addWidgets,
                ),
              ),
            ],
          ),
        ));
  }
}

class ItemDonationWidget extends StatefulWidget {
  const ItemDonationWidget({super.key});

  @override
  State<ItemDonationWidget> createState() => _ItemDonationWidgetState();
}

class _ItemDonationWidgetState extends State<ItemDonationWidget> {
  final List<String> _selected = [
    'Staple Food',
    'Packaged Food',
    'Coocked Food',
  ];
  String Selected_item = 'Staple Food';

  TextEditingController controller_quantity = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_expirydate = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? documentId;

  Future<void> _saveUserData(String itemname, int quantinty,
      Timestamp expirydate, String selectedtype) async {
    try {
      DocumentReference donationRef =
          await _firestore.collection('donations').add({
        'username': DataClass.username,

        //'foodbank': foodbank,
      });
      setState(() {
        documentId = donationRef.id;
      });

      print("Data saved successfully with document ID: $documentId");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  Future<void> _addFoodItem(String collectionName, String itemName,
      int quantity, DateTime expiryDate) async {
    try {
      if (documentId == null) {
        print("Error: Document ID is null");
        return;
      }

      // Add a new item to the selected subcollection under donations
      await _firestore
          .collection('donations')
          .doc(documentId)
          .collection(collectionName)
          .add({
        'itemName': itemName,
        'quantity': quantity,
        'expiryDate': Timestamp.fromDate(expiryDate),
      });

      print("Food item added successfully to $collectionName");
    } catch (e) {
      print("Error adding food item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text_Theme.text_colored(
                "Select Food Type", 24, Color.fromARGB(221, 0, 0, 0)),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: Selected_item,
            items: _selected.map(
              (String dropDownStringItem) {
                return DropdownMenuItem(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              },
            ).toList(),
            onChanged: (String? newSelectedValue) {
              setState(() {
                Selected_item = newSelectedValue!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: controller_name,
                decoration: const InputDecoration(
                    hintText: "Enter your quantity in kg/meals",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: controller_quantity,
                decoration: const InputDecoration(
                    hintText: "Enter your quantity in kg/meals",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: controller_expirydate,
                decoration: const InputDecoration(
                    hintText: "Enter expiry date",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder())),
          ),
        ],
      ),
    );
  }
}
