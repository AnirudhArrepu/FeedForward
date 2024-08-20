import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/classes/leaderboard_class.dart';
import 'package:flutter/material.dart';

class LeaderboardDonations extends StatefulWidget {
  const LeaderboardDonations({super.key});

  @override
  State<LeaderboardDonations> createState() => _LeaderboardDonationsState();
}

class _LeaderboardDonationsState extends State<LeaderboardDonations> {
  @override
  void initState() {
    super.initState();
    loadingLeaderboard();
  }

  void loadingLeaderboard() async {
    await LeaderboardClass.allocatePointsDonations();
    await LeaderboardClass.allocatePointsVolunteers();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.bgcolor(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Donation Leaderboard",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: [
          const SizedBox(
            height: 70,
          ),
          Container(
            color: const Color.fromARGB(255, 35, 137, 38),
            height: 30,
            width: 120,
            child: const Center(
              child: Text(
                "Donations",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 35, 137, 38),
            height: 500,
            child: ListView.builder(
              itemCount: LeaderboardClass.userPointsDonations.length < 10
                  ? LeaderboardClass.userPointsDonations.length
                  : 10,
              itemBuilder: (BuildContext context, int index) {
                String user = LeaderboardClass.userPointsSortedDonations.entries
                    .toList()[index]
                    .key;
                return ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  title: Text(user),
                );
              },
            ),
          ),
        ]));
  }
}
