import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:teledoc/HealthSpecialistMenu/agender.dart';

import 'package:teledoc/Menu/ProfileScreen.dart';

import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/home/HealthDetailsAgender.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/screen/appoint_form.dart';
import 'package:teledoc/variable.dart';

class HealthSpecialistDetailPage extends StatefulWidget {
  final uid;
  final address;
  final image_url;
  final name;
  final speciality;
  const HealthSpecialistDetailPage({
    Key? key,
    required this.uid,
    this.address,
    this.image_url,
    this.name,
    this.speciality,
  }) : super(key: key);

  @override
  _HealthSpecialistDetailPageState createState() =>
      _HealthSpecialistDetailPageState();
}

class _HealthSpecialistDetailPageState
    extends State<HealthSpecialistDetailPage> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1; // from 0-1.0
  double _width = 350;
  double _height = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: -0.0,
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
        backgroundColor: Color(4279583578),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              height: 260,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: Image.network(
                '${widget.image_url}',
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                        height: 260,
                        color: Colors.grey.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Column(children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipOval(
                                child: Image.network(
                                  "${widget.image_url}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "Dr ${widget.name}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Center(
                            child: Text(
                              "${widget.speciality}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ])))),
            // Make appointment Button
            Padding(
              padding: EdgeInsets.only(top: 235),
              child: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      _showMyDialog(
                          "Please select a case in doctor agener below");
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => Appointment_Form(
                      //         uid: widget.uid, name: widget.name)));
                    },
                    child: Center(
                      child: Text(
                        "Select Availability In Agender",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 1 Box shadox Box with information
            Container(
              margin: EdgeInsets.only(top: 300),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset.zero,
                              color: Colors.grey)
                        ]),
                    height: 200,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 20),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "${widget.address}",
                                    style: TextStyle(color: Color(4279583578)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 6),
                                  child: Icon(
                                    Icons.money_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 4),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Tariffs and refunds ",
                                        style: TextStyle(
                                            color: Color(4279583578),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        "15 000 XAF Per Consultation",
                                        style: TextStyle(
                                            color: Color(4279583578),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 6),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 4),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Means of payment",
                                        style: TextStyle(
                                            color: Color(4279583578),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Payment MTN Money, Orange Money",
                                          style: TextStyle(
                                              color: Color(4279583578),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Time schecule
            Container(
              margin: EdgeInsets.only(top: 510),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero,
                          color: Colors.grey)
                    ]),
                height: 470,
                child: HealthDetailsAgendar(
                  hpID: widget.uid,
                  name: widget.name,
                ),
              ),
            ),

            // 2 Box shadow Button
            Container(
              margin: EdgeInsets.only(top: 990, bottom: 30),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset.zero,
                              color: Colors.grey)
                        ]),
                    height: 170,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Icon(
                                    Icons.list,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 20),
                                  width: 200,
                                  child: Text(
                                    "Presentation",
                                    style: TextStyle(
                                        color: Color(4279583578),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 4,
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Icon(
                                    Icons.schedule,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 4),
                                  width: 200,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Available time           ",
                                        style: TextStyle(
                                            color: Color(4279583578),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Icon(
                                    Icons.model_training_sharp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, left: 4),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Training                     ",
                                        style: TextStyle(
                                            color: Color(4279583578),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Note'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Look'),
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

  demoDate(String day, String date, bool isSelected) {
    return isSelected
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 0),
            child: Container(
              width: 70,
              margin: EdgeInsets.only(
                right: 15,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Color(4279583578),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      day,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      date,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 0),
            child: Container(
              width: 70,
              margin: EdgeInsets.only(
                bottom: 10,
                right: 15,
              ),
              decoration: BoxDecoration(
                color: Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      day,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      date,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  doctorTiming(String time) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 10,
      ),
      decoration: BoxDecoration(
          color: Color(4279583578), borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 2),
            child: Icon(
              Icons.access_time,
              color: Colors.white,
              size: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              time,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
