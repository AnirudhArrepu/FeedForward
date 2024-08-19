import 'package:fbm_app/Button/button.dart';
import 'package:fbm_app/Styles/BgColor.dart';
import 'package:fbm_app/Styles/TextStyle.dart';
import 'package:flutter/material.dart';

class Volunteers extends StatelessWidget {
  const Volunteers({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> Volunteers = [];

    void getVolunteerInfo(){
      
    }
    return Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          backgroundColor: AppTheme.secondaryColor,
          title: Text(
            "VOLUNTEERS",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 246, 244, 244)),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: Volunteers.length,
              itemBuilder: (BuildContext context, int index) {
                final serial = index + 1;
                final volun = Volunteers[index];
                return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: ListTile(
                      title: Column(children: [
                        Text_Theme.text_size(serial.toString(), 22),
                        Text_Theme.text_size(volun.keys.first, 22),
                      ]),
                      subtitle: Text_Theme.text_size(volun.values.first, 22),
                    ));
              },
            ),
          ],
        ));
  }
}
