import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teledoc/Authentication/loginAndSignUp.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/Menu/chatScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/home/SearchTab.dart';
import 'package:teledoc/home/searchMap.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/NewsHome.dart';
import 'package:teledoc/screen/appointment.dart';
import 'package:teledoc/variable.dart';

class SearchPage extends StatefulWidget {
  final List<dynamic> tempStore ;
  const SearchPage({Key? key, required this.tempStore}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getCurrentUserProfilePic();
  }

  Future<void> getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await patientsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  name = doc.get('username');
                  print(name);
                });
              }
            }));
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
    Size size = MediaQuery.of(context).size;
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
          bottom: TabBar(
              controller: tabController,
              tabs: [buildTab("Search"), buildTab("Map")]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [SearchTab(tempStore:widget.tempStore, ), SearchMap(tempStore:widget.tempStore,)],
        ));
  }
}
