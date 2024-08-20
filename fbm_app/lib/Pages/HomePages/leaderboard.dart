import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/classes/leaderboard_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class leaderboard extends StatelessWidget {
  const leaderboard({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgcolor(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () => {
          Navigator.pushNamed(context, '/emergency'),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            butt(
              text: "Donors",
              routeName: '/l_donation',
              icon: Icon(Icons.people),
            ),
            SizedBox(
              height: 50,
            ),
            butt(
              text: "Volunteers",
              routeName: '/l_volunteers',
              icon: Icon(Icons.volunteer_activism),
            )
          ],
        ),
      ),
    );
  }
}
