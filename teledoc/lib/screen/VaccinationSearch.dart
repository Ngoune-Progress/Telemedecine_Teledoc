import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teledoc/VaccinationsTab.dart/VaccinationMap.dart';
import 'package:teledoc/VaccinationsTab.dart/VaccinationTab.dart';
import 'package:teledoc/variable.dart';

class VaccinationSearchPage extends StatefulWidget {
  final List<dynamic> tempStore;
  const VaccinationSearchPage({Key? key, required this.tempStore})
      : super(key: key);

  @override
  _VaccinationSearchPageState createState() => _VaccinationSearchPageState();
}

class _VaccinationSearchPageState extends State<VaccinationSearchPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // getCurrentUserProfilePic();
  }

  // Future<void> getCurrentUserProfilePic() async {
  //   var userId = FirebaseAuth.instance.currentUser!.uid;
  //   await hospitalCollection
  //       .get()
  //       .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
  //             if (doc.get('uid').toString() == userId) {
  //               setState(() {
  //                 name = doc.get('username');
  //                 print(name);
  //               });
  //             }
  //           }));
  // }

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
          children: [
            VaccinationSearchTab(
              tempStore: widget.tempStore,
            ),
            VaccinationMap(
              tempStore: widget.tempStore,
            )
          ],
        ));
  }
}
