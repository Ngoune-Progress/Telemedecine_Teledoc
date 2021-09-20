import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/Menu/chatScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/NewsHome.dart';
import 'package:teledoc/patientProfile.dart';
import 'package:teledoc/screen/VaccinationSearch.dart';
import 'package:teledoc/screen/appointment.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/variable.dart';

class VaccinationSearch extends StatefulWidget {
  const VaccinationSearch({Key? key}) : super(key: key);

  @override
  _VaccinationSearchState createState() => _VaccinationSearchState();
}

class _VaccinationSearchState extends State<VaccinationSearch> {
  TextEditingController specialityController = TextEditingController();
  String name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserProfilePic();
  }

  String imageurl = '';
  Future<void> getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await patientsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  name = doc.get('username');
                  imageurl = doc.get('imageUrl');
                  print(name);
                });
              }
            }));
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  searchByName(String searchField) {
    return hospitalCollection
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toLowerCase())
        .get();
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toLowerCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      searchByName(value).then((QuerySnapshot d) {
        for (int i = 0; i < d.docs.length; ++i) {
          queryResultSet.add(d.docs[i].data());
          print(queryResultSet);
        }
      });
    } else {
      setState(() {
        tempSearchStore = [];
      });
      queryResultSet.forEach((element) {
        if (element['vaccine'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Image.asset(
          'assets/images/log2.png',
          height: MediaQuery.of(context).size.height / 10,
        ),
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
                    child: imageurl.isEmpty
                        ? Image.asset("assets/images/prof.png")
                        : ClipOval(
                            child: Image.network(
                              '$imageurl',
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VaccinationSearch()));
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
                  MaterialPageRoute(builder: (context) => PatientChatScreen()));
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => APpointment()));
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      )),
      backgroundColor: Colors.blue,
      body: Container(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: demoTopRatedDoctor(),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(top: 350),
                      height: 300,
                      child: Image.asset(
                        "assets/images/it.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      )),
    );
  }

  Widget demoTopRatedDoctor() {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 2,
                  offset: Offset.zero)
            ]),
        margin: EdgeInsets.only(top: 60, bottom: 7),
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tempSearchStore.isNotEmpty
                ? Container(
                    child: Row(
                      children: [
                        Container(
                          child: Icon(Icons.gpp_good),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text("We found a result"),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Book a vaccination appointment at a health center ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(4293718774),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              child: TextField(
                                autofocus: false,
                                controller: specialityController,
                                maxLines: 1,
                                onChanged: (val) {
                                  initiateSearch(val.trim());
                                  if (tempSearchStore.isNotEmpty) {
                                    FlutterRingtonePlayer.playNotification();
                                  }
                                },
                                style: TextStyle(
                                    color: Color(0xff107163), fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Disease,",
                                    hintStyle:
                                        TextStyle(color: Color(4287471531))),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(4294938370),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  color: Colors.white,
                                  iconSize: 25,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VaccinationSearchPage(
                                                  tempStore: tempSearchStore,
                                                )));
                                  },
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
