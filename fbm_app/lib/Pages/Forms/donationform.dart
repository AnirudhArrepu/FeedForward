import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:flutter/material.dart';
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
    widgets.add(ItemDonationWidget(
      key: GlobalKey<_ItemDonationWidgetState>(),
      foodbank: widget.foodbank,
    ));
    setState(() {});
  }

  Future<void> submitDonation() async {
    for (var widget in widgets) {
      await widget.saveDonation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text(
          "Donation Form",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(235, 0, 0, 0),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            for (int i = 0; i < widgets.length; i++) widgets[i],
            const SizedBox(height: 40),
            FloatingActionButton.extended(
              label: const Text("Submit Donation"),
              backgroundColor: AppTheme.secondaryColor,
              onPressed: () async {
                await submitDonation();
              },
              icon: const Icon(Icons.handshake),
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              label: const Text("Add Item"),
              icon: const Icon(Icons.add),
              onPressed: addWidgets,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDonationWidget extends StatefulWidget {
  final String foodbank;

  const ItemDonationWidget({super.key, required this.foodbank});

  Future<void> saveDonation(BuildContext context) async {
    final state = _ItemDonationWidgetState.of(this);
    if (state == null) return;
    await state.saveUserData(context);
    await state.addFoodItem(context);
  }

  @override
  State<ItemDonationWidget> createState() => _ItemDonationWidgetState();
}

class _ItemDonationWidgetState extends State<ItemDonationWidget> {
  final List<String> _selected = [
    'Staple Food',
    'Packaged Food',
    'Cooked Food',
  ];
  String selectedFoodType = 'Staple Food';

  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerExpiryDate = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? documentId;

  static _ItemDonationWidgetState? of(ItemDonationWidget widget) {
    return widget.key is GlobalKey<_ItemDonationWidgetState>
        ? (widget.key as GlobalKey<_ItemDonationWidgetState>).currentState
        : null;
  }

  Future<void> saveUserData(BuildContext context) async {
    try {
      DocumentReference donationRef =
          await _firestore.collection('donations').add({
        'username': DataClass.username,
        'foodbank': widget.foodbank,
      });

      setState(() {
        documentId = donationRef.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving donation data: $e')),
      );
    }
  }

  Future<void> addFoodItem(BuildContext context) async {
    try {
      if (documentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Document ID is null')),
        );
        return;
      }

      int quantity = int.tryParse(controllerQuantity.text) ?? 0;
      DateTime expiryDate =
          DateTime.tryParse(controllerExpiryDate.text) ?? DateTime.now();

      await _firestore
          .collection('donations')
          .doc(documentId)
          .collection(selectedFoodType)
          .add({
        'itemName': controllerName.text,
        'quantity': quantity,
        'expiryDate': Timestamp.fromDate(expiryDate),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food item added successfully to $selectedFoodType!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding food item: $e')),
      );
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
              "Select Food Type",
              24,
              const Color.fromARGB(221, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedFoodType,
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
                selectedFoodType = newSelectedValue!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                hintText: "Enter Item Name",
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerQuantity,
              decoration: const InputDecoration(
                hintText: "Enter Quantity in kg/meals",
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  setState(() {
                    controllerExpiryDate.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: controllerExpiryDate,
                  decoration: const InputDecoration(
                    hintText: "Enter Expiry Date",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
