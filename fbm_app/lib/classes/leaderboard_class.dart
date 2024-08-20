import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardClass {
  static String winnerVolunteer = "";
  static String winnerDonation = "";

  //Donations
  static Map<String, int> userPointsSortedDonations = {};
  static Map<String, int> userPointsDonations = {};
  //Volunteers
  static Map<String, int> userPointsSortedVolunteers = {};
  static Map<String, int> userPointsVolunteers = {};

  static Future<void> allocatePointsVolunteers() async {
    userPointsDonations = {};
    userPointsSortedDonations = {};
    await allocatePointsVolunteersDuplicate();
    rankUsersVolunteers();
  }

  static Future<void> allocatePointsDonations() async {
    userPointsSortedVolunteers = {};
    userPointsVolunteers = {};
    await allocatePointsDonationsDuplicate();
    rankUsersDonations();
  }

  static Future<void> allocatePointsVolunteersDuplicate() async {
    CollectionReference volunteers =
        FirebaseFirestore.instance.collection('volunteers');

    QuerySnapshot querySnapshot = await volunteers.get();

    for (var data in querySnapshot.docs) {
      String username = data['username'];
      int hours = data['hours'];

      if (userPointsVolunteers.containsKey(username)) {
        userPointsVolunteers[username] =
            userPointsVolunteers[username]! + hours;
      } else {
        userPointsVolunteers[username] = hours;
      }
    }
  }

  static void rankUsersVolunteers() {
    userPointsSortedVolunteers = Map.fromEntries(
        userPointsVolunteers.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)));

    if (userPointsSortedVolunteers.isNotEmpty) {
      winnerVolunteer = userPointsSortedVolunteers.entries.first.key;
    }
  }

  static Future<void> allocatePointsDonationsDuplicate() async {
    CollectionReference donations =
        FirebaseFirestore.instance.collection('donations');
    QuerySnapshot querySnapshot = await donations.get();

    for (var doc in querySnapshot.docs) {
      String username = doc['username'];
      if (userPointsDonations.containsKey(username)) {
        userPointsDonations[username] = await calculatePointsDonations(doc) +
            userPointsDonations[username]!;
      } else {
        userPointsDonations[username] = await calculatePointsDonations(doc);
      }
    }
  }

  static void rankUsersDonations() {
    userPointsSortedDonations = Map.fromEntries(
        userPointsDonations.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)));

    if (userPointsSortedDonations.isNotEmpty) {
      winnerDonation = userPointsSortedDonations.keys.first;
    }
  }

  static Future<int> calculatePointsDonations(QueryDocumentSnapshot doc) async {
    CollectionReference packagedSubCollection =
        doc.reference.collection('Packaged Food');
    CollectionReference stapleSubCollection =
        doc.reference.collection('Staple Food');
    CollectionReference cookedSubCollection =
        doc.reference.collection('Cooked Food');

    QuerySnapshot packagedQuery = await packagedSubCollection.get();
    QuerySnapshot stapleQuery = await stapleSubCollection.get();
    QuerySnapshot cookedQuery = await cookedSubCollection.get();

    int points = 0;

    for (var doc in packagedQuery.docs) {
      points = points + int.parse((doc['quantity'] * 7).toString());
    }
    for (var doc in stapleQuery.docs) {
      points = points + int.parse((doc['quantity'] * 5).toString());
    }
    for (var doc in cookedQuery.docs) {
      points = points + int.parse((doc['quantity'] * 10).toString());
    }

    return points;
  }
}
