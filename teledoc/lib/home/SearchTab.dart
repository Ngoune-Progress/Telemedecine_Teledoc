import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:teledoc/home/healthSpecialistDetail.dart';
import 'package:teledoc/model/doctors.dart';
import 'package:teledoc/variable.dart';

class SearchTab extends StatefulWidget {
  final List<dynamic> tempStore;
  const SearchTab({Key? key, required this.tempStore}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController specialityController = TextEditingController();
  bool isLoading = false;
  bool tap = false;

  var queryResultSet = [];
  var tempSearchStore = [];
  searchByName1() {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return appointmentCollection.where('Patient_Id', isEqualTo: userId).get();
  }

  // initiateSearch() {
  //   searchByName1().then((QuerySnapshot d) {
  //     for (int i = 0; i < d.docs.length; ++i) {
  //       check.add(d.docs[i].data());
  //     }
  //   });
  // }

  // searchByName(String searchField) {
  //   return doctorsCollections
  //       .where('searchKey',
  //           isEqualTo: searchField.substring(0, 1).toLowerCase())
  //       .get();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // StreamBuilder(
                    //     stream: doctorsCollections
                    //         .where('speciality',
                    //             isEqualTo: specialityController.text)
                    //         .snapshots(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot> snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Center(
                    //           child: Container(
                    //             margin: EdgeInsets.only(top: 100),
                    //             height: 50,
                    //             width: 50,
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       }
                    //       return ListView(
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         children: snapshot.data!.docs.map((document) {
                    //           return Center(
                    //               child: demoTopRatedDoctor(
                    //                   document['uid'],
                    //                   document['Address'],
                    //                   document['image_url'],
                    //                   document['name'],
                    //                   document['speciality'],
                    //                   "4.5",
                    //                   context,
                    //                   "2000"));
                    //         }).toList(),
                    //       );
                    //     })

                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: widget.tempStore.map((element) {
                          return demoTopRatedDoctor(
                              element['uid'],
                              element['Address'],
                              element['image_url'],
                              element['name'],
                              element['speciality'],
                              "4.5",
                              context,
                              "2000");
                        }).toList())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchHP(String key) async {
    setState(() {
      isLoading = true;
      tap = true;
    });
  }

  doctorTiming(String time) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 2),
            child: Center(
              child: Text(
                time,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget demoTopRatedDoctor(
      String uid,
      String address,
      String image,
      String name,
      String speciality,
      String rating,
      BuildContext context,
      String amount) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HealthSpecialistDetailPage(
                        uid: uid,
                        address: address,
                        image_url: image,
                        name: name,
                        speciality: speciality,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: Offset.zero)
              ]),
          margin: EdgeInsets.only(top: 10, bottom: 7),
          height: 250,
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 90,
                        width: 90,
                        child: ClipOval(
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 260,
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  // flex: 5,
                                  child: Container(
                                    child: Text(
                                      "Dr $name",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: -1,
                                    child: Container(
                                      child: FavoriteButton(
                                        iconSize: 40,
                                        valueChanged: (_isFavorite) {
                                          print('Is Favorite $_isFavorite)');
                                        },
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Bill Amount: $amount FCFA",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    speciality,
                                    style: TextStyle(
                                        color: Color(0xffababab),
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 3, left: size.width * 0.25),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          "Rating:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          rating,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
              Divider(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    child: Text(
                  "NEXT AVAILABILITY",
                  style: TextStyle(color: Color(0xffababab), fontSize: 15),
                )),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(right: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    doctorTiming("Mon"),
                    doctorTiming("Tue"),
                    doctorTiming("Wed"),
                    doctorTiming("Thu"),
                    doctorTiming("Fri"),
                    doctorTiming("Sat"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "Rate: ",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding: EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) async {
                           
                            bool isRate = false;
                            bool hasAppoint = false;
                            var userId = FirebaseAuth.instance.currentUser!.uid;
                            rateCollection.get().then(
                                (QuerySnapshot snapshot) =>
                                    snapshot.docs.forEach((doc) async {
                                      if (doc.get('patient_id') == userId &&
                                          doc.get('hp_id') == uid) {
                                        setState(() {
                                          isRate = true;
                                          print(1);
                                        });
                                      }

                                      if (isRate == true) {
                                        _showMyDialog(
                                            'You already rated this Health specialist');
                                      } else {
                                        appointmentCollection.get().then(
                                            (QuerySnapshot snapshot) => snapshot
                                                    .docs
                                                    .forEach((doc) async {
                                                  if (doc.get('Patient_Id') ==
                                                          userId &&
                                                      doc.get('Hp_Id') == uid) {
                                                    setState(() {
                                                      hasAppoint = true;
                                                    });
                                                  }
                                                  if (hasAppoint == false) {
                                                    _showMyDialog(
                                                        'You never had an appointment with Health specialist');
                                                  } else {
                                                    rateCollection.doc().set({
                                                      'rate': rating,
                                                      'patient_id': userId,
                                                      'hp_id': uid
                                                    });
                                                    _showMyDialog1(
                                                        'Rate succesfully save rate $rating');
                                                  }
                                                }));
                                      }
                                    }));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _showMyDialog1(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.star,
            size: 100,
            color: Colors.amber,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('Success')),
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Rate not save.'),
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialog1(BuildContext context) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            child: SizedBox.expand(
                child: Center(
              child: Container(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "You can't rate the doctor if you never had an appointment with him",
                        style: TextStyle(fontSize: 30),
                      ),
                      // Container(
                      //   child: Text(
                      //     "Please verify email and password",
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 10,
                      //         decoration: TextDecoration.none),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            )),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
