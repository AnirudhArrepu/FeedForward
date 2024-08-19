import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class DataClass {
  static String username = "";
  static String foodbank = "";

  static List<Map<String, LatLng>> foodbankWithLocation = [];
  static List<String> foodbankWithoutLocation = [];

  static void addUsername(String name){
    username = name;
    if(foodbankWithoutLocation.)
  }

  static void loadFoodbanks() async {
    CollectionReference foodbanks =
        FirebaseFirestore.instance.collection('foodbank');
    QuerySnapshot querySnapshot = await foodbanks.get();

    for (var doc in querySnapshot.docs) {
      String name = doc['name'];
      GeoPoint location = doc['location'];
      LatLng latlng = LatLng(location.latitude, location.longitude);
      foodbankWithLocation.add({name: latlng});
      if (name == 'AkshayPatra') {
        continue;
      }
      foodbankWithoutLocation.add(name);
    }
  }
}
