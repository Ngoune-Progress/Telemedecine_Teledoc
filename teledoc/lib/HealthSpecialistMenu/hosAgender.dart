import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/HealthSpecialistMenu/Hpchat.dart';
import 'package:teledoc/HealthSpecialistMenu/agender.dart';
import 'package:teledoc/HealthSpecialistMenu/chart.dart';
import 'package:teledoc/HealthSpecialistMenu/eventEditing.dart';
import 'package:teledoc/HealthSpecialistMenu/prescription.dart';
import 'package:teledoc/HealthSpecialistMenu/scanner.dart';
import 'package:teledoc/Hp_coference/hp_meeting.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/newsHomeHP.dart';

import '../variable.dart';

class HosAgender extends StatefulWidget {
  const HosAgender({Key? key}) : super(key: key);

  @override
  _HosAgenderState createState() => _HosAgenderState();
}

class _HosAgenderState extends State<HosAgender> {
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      )),
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EventEditingPage()))),
    );
  }
}
