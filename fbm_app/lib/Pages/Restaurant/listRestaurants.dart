import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Styles/BgColor.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  @override
  Widget build(BuildContext context) {
   /* final List<String> restaurants_ = [
      'R1',
      'R2',
      'R3',
      'R4',
      'R5',
      'R6',
      'R7'
    ];*/
    return Scaffold(
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        backgroundColor: AppTheme.titleColor(),
        title: const Text(
          "RESTAURANTS",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 1)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Restaurants Found"));
            }
            
            final restaurants = snapshot.data!.docs;
        
        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (BuildContext context, int index) {
            final restaurant = restaurants[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: Text(
                'R${index+1}',
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name :${restaurant['name']}' ?? 'Restaurant Name',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  SizedBox(height: 10),
                  Text(
                    'Address :${restaurant['address']}' ?? 'Restaurant Address',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                 
                  SizedBox(height: 10),
                  Text(
                    'Contact no:${restaurant['contactnum']}' ?? 'Restaurant Contactno',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                  SizedBox(height: 10),
                ],
              ),
            );
          }
        );
        },
            ),
      ),
    );
  }
}
