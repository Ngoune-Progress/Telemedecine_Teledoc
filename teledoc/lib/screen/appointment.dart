import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/Menu/chatScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/appointmentPage.dart/AppointWithDoctor.dart';
import 'package:teledoc/appointmentPage.dart/VaccineViewAppoit.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/NewsHome.dart';
import 'package:teledoc/patientProfile.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/screen/vaccinationPage.dart';
import 'package:teledoc/variable.dart';

class APpointment extends StatefulWidget {
  const APpointment({Key? key}) : super(key: key);

  @override
  _APpointmentState createState() => _APpointmentState();
}

class _APpointmentState extends State<APpointment>
    with SingleTickerProviderStateMixin {
  var queryResultSet = [];
  String? userId;
  String name = '';
  TabController? tabController;
  String imageurl = '';
  Future<void> getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await patientsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  name = doc.get('username');
                  imageurl = doc.get('image_url');
                  print(name);
                });
              }
            }));
  }

  searchByName() {
    return appointmentCollection.where('Patient_Id', isEqualTo: userId).get();
  }

  initiateSearch() async {
    await searchByName().then((QuerySnapshot d) {
      for (int i = 0; i < d.docs.length; ++i) {
        queryResultSet.add(d.docs[i].data());
        print('object');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getCurrentUserProfilePic();
    initiateSearch();
  }

  buildTab(String name) {
    return Container(
      height: 50,
      width: 150,
      child: Center(child: Text(name)),
    );
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
          bottom: TabBar(controller: tabController, tabs: [
            buildTab("Doctor Appointment"),
            buildTab("Vaccine Appointment")
          ]),
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
                        child: imageurl == ''
                            ? Image.asset("assets/images/prof.png")
                            : ClipOval(
                                child: Image.network(
                                  '$imageurl',
                                  fit: BoxFit.cover,
                                ),
                              )),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      height: 20,
                      width: 150,
                      child: Center(
                        child: Text(
                          "$name",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeMain()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.h_mobiledata,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Search Vaccination",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VaccinationSearch()));
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PatientChatScreen()));
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
                    MaterialPageRoute(builder: (context) => NewsScreen()));
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
                    builder: (context) => VideoConferenceScreen()));
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
                    MaterialPageRoute(builder: (context) => PatientProfile()));
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
        body: TabBarView(
          controller: tabController,
          children: [
            AppointWithDoctor(
              result: queryResultSet,
            ),
            VaccineViewAppoint()
          ],
        ));
  }
}
