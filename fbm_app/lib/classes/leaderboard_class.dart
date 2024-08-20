import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardClass {
  static String winnerVolunteer = "";
  static String winnerDonation = " ";

  //Donations
  static Map<String, int> userPointsSortedDonations = {};
  static Map<String, int> userPointsDonations = {};
  //Volunteers
  static Map<String, int> userPointsSortedVolunteers = {};
  static Map<String, int> userPointsVolunteers = {};

  static void allocatePointsVolunteers() {
    userPointsDonations = {};
    userPointsSortedDonations = {};
    allocatePointsVolunteersDuplicate();
    rankUsersVolunteers();
  }

  static void allocatePointsDonations() {
    userPointsSortedVolunteers = {};
    userPointsVolunteers = {};
    allocatePointsDonationsDuplicate();
    rankUsersDonations();
  }

  static void allocatePointsVolunteersDuplicate() async {
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

    winnerVolunteer = userPointsSortedVolunteers.entries.first.key;
  }

  static void allocatePointsDonationsDuplicate() async {
    CollectionReference donations =
        FirebaseFirestore.instance.collection('donations');
    QuerySnapshot querySnapshot = await donations.get();

    for (var doc in querySnapshot.docs) {
      String username = doc['username'];
      if (userPointsDonations.containsKey(username)) {
        userPointsDonations[username] =
            calculatePointsDonations(doc) + userPointsDonations[username]!;
      } else {
        userPointsDonations[username] = calculatePointsDonations(doc);
      }
    }
  }

  static void rankUsersDonations() {
    userPointsSortedDonations = Map.fromEntries(
        userPointsDonations.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)));

    winnerDonation = userPointsSortedDonations.entries.first.key;
  }

  static int calculatePointsDonations(QueryDocumentSnapshot doc) {
    return doc['rice (kg)'] * 1 +
        doc['bread'] * 2 +
        doc['pulses'] * 3 +
        doc['simple_meals'] * 5 +
        doc['complex_meals'] * 7;
  }
}
