import 'package:fbm_app/Button/elevatedbutton.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:fbm_app/classes/notification_class.dart';
import 'package:flutter/material.dart';

class Emergency extends StatefulWidget {
  const Emergency({super.key});

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text_Theme.text_size("EMERGENCY", 20),
          leading: Padding(
              padding: EdgeInsets.all(4),
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              )),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
            ),
            GestureDetector(child: button2(),
            onTap: () => NotificationClass('EMERGENCY', '${DataClass.username} has reported', false, true),),
          ],
        )));
  }
}
