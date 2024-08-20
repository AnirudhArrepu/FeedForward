import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/classes/leaderboard_class.dart';
import 'package:flutter/material.dart';

class LeaderboardVolunteer extends StatelessWidget {
  const LeaderboardVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Volunteer Leaderboard",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(
            height: 70,
          ),
           Container(
            color: Colors.brown,
            height: 30,
            width: 120,
            child: const Center(
              child: Text(
                "Volunteer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        Container(
            color: Colors.brown,
            height: 500,
            child: ListView.builder(
              itemCount:
                  LeaderboardClass.userPointsSortedVolunteers.length < 10
                      ? LeaderboardClass.userPointsSortedVolunteers.length
                      : 10,
              itemBuilder: (BuildContext context, int index) {
                var user = LeaderboardClass.userPointsSortedVolunteers.entries
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
        ]
    )
    );
  }
}