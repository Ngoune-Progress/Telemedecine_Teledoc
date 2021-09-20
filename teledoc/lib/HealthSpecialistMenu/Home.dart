import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teledoc/HealthSpecialistMenu/Hpchat.dart';
import 'package:teledoc/HealthSpecialistMenu/agender.dart';
import 'package:teledoc/HealthSpecialistMenu/chart.dart';
import 'package:teledoc/HealthSpecialistMenu/eventEditing.dart';
import 'package:teledoc/HealthSpecialistMenu/hosAgender.dart';
import 'package:teledoc/HealthSpecialistMenu/prescription.dart';
import 'package:teledoc/HealthSpecialistMenu/scanner.dart';
import 'package:teledoc/Hp_coference/hp_meeting.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/newsHomeHP.dart';
import 'package:teledoc/variable.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  String? url;
  String? name;
  getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await doctorsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  url = doc.get('image_url');
                  name = doc.get('name');
                });
              }
            }));
  }

// Stack(children: [
//       Align(
//         alignment: Alignment.center,
//         child: Container(
//           height: 300,
//           width: 300,
//           decoration: BoxDecoration(color: Colors.white, boxShadow: [
//             BoxShadow(blurRadius: 8, spreadRadius: 0, color: Colors.grey)
//           ]),
//         ),
//       ),
//     ]);
  @override
  void initState() {
    // TODO: implement initState

    getCurrentUserProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/log2.png',
            height: MediaQuery.of(context).size.height / 10,
          ),
          actions: [
            // Notification bar icon
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
            // Dont forget to insert images please peet
            // GestureDetector(
            //    child: Container(
            //      child: Image.network(),
            //    ),
            // )
          ],
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipOval(
                        child: Image.network(
                          "$url",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      height: 20,
                      width: 150,
                      child: Center(
                        child: Text(
                          '$name',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Agender",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DoctorHomePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Chat",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HpChat()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.schedule,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Appointments",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.file_copy,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Prescription",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Prescription()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.new_releases_rounded,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "News",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => NewsScreen1()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.meeting_room,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Meetings",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VideoConferenceScreenHP()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.qr_code_scanner,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Scannner",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ScannerPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.show_chart,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Analysis",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LineChart()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Account",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Offline",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                try {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        )),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/top.jpeg"),
            fit: BoxFit.cover,
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8, spreadRadius: 0, color: Colors.grey)
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Center(
                            child: Text(
                          'Set Availability For A Hospital',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          list(
                            'Hopital genral the yalounde',
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  list(String text) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: Container(child: Text('Choose'))),
          Expanded(
              flex: 6,
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 15),
                  ))),
          Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HosAgender()));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
