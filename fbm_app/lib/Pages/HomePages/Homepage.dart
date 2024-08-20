import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbm_app/Pages/Forms/create_FB.dart';
import 'package:fbm_app/Pages/HomePages/leaderboard.dart';
import 'package:fbm_app/Pages/Restaurant/Rprofile.dart';
import 'package:fbm_app/Pages/User/FB_profile.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:fbm_app/classes/leaderboard_class.dart';
import 'package:fbm_app/classes/notification_class.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Button/button.dart';
import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  const Homepage({super.key, required this.userDetails});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late int r;
  late Map<String, dynamic> Profile;
  static const List<String> route = ['/profile', '/rprofile'];

  @override
  void initState() {
    super.initState();
    r = widget.userDetails['role'];
    Profile = widget.userDetails;
    DataClass.addUsername(widget.userDetails['name']);

    LeaderboardClass.allocatePointsDonations();
  }

  @override
  Widget build(BuildContext context) {
    List<String> idioms = [
      "\"Share your food; feed a hungry heart today.\"",
      "\"One meal can make a world of difference.\"",
      "\"Your donation: a lifeline to someone in need.\"",
      "\"Help us turn hunger into hope with your generosity.\"",
      "\"Feed a family; make a lasting impact with your gift.\"",
      "\"Small act, big change: donate food and spread kindness.\"",
      "\"Every can counts—help us end hunger together.\"",
      "\"Give food, give hope; be a hero in someones life.\"",
      "\"Together, we can turn hunger into hope. Donate now!\""
    ];
    return Scaffold(
        backgroundColor: AppTheme.bgcolor(),
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              )),
          // backgroundColor: AppTheme.titleColor(),
          title: Text_Theme.text_size("FeedForward", 20),
          centerTitle: true,
        ),
        body: GestureDetector(
          onDoubleTap: () => {
            Navigator.pushNamed(context, '/emergency'),
          },
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text_Theme.text_size(
                            '${LeaderboardClass.winnerDonation}', 20),
                        subtitle: Text_Theme.text_size('is no.1 donor', 15),
                      )),
                  Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text_Theme.text_size(
                            '${LeaderboardClass.winnerVolunteer}', 20),
                        subtitle: Text_Theme.text_size('is no.1 volunteer', 15),
                      )),
                  SingleChildScrollView(
                    child: Container(
                        height: 325,
                        child: ListView.builder(
                            itemCount: NotificationClass.notifications.length,
                            itemBuilder: (context, index) {
                              final noti =
                                  NotificationClass.notifications[index];
                              return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16.0),
                                  child: ListTile(
                                    title: Text_Theme.text_size(noti.title, 20),
                                    subtitle:
                                        Text_Theme.text_size(noti.subtitle, 15),
                                  ));
                            })),
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Center(
                    child: Container(
                      height: 40,
                      child: Text_Theme.text_white(
                          idioms[Random().nextInt(idioms.length)]),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 70,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (r == 0) {
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        FbProfile(proDetails: Profile)));
                          }
                        }
                        if (r == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) =>
                                      RestaurantProfile(RDetails: Profile)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 243, 4, 4),
                          padding: EdgeInsets.symmetric(
                              horizontal: 85, vertical: 15)),
                      icon: const Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "PROFILE",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 60),
                      SizedBox(width: 80),
                      butt(
                          text: "    MAP      ",
                          routeName: "/map",
                          icon: Icon(Icons.location_on)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    butt(
                        text: "LEADERBOARD",
                        routeName: "/leaderboard",
                        icon: Icon(Icons.emoji_events)),
                    SizedBox(width: 10),
                    butt(
                        text: "WASTE\nMANAGEMENT",
                        routeName: "/waste",
                        icon: Icon(Icons.recycling_rounded)),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                ]),
          ),
        ));
  }
}
