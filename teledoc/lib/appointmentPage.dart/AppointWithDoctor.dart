import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:teledoc/variable.dart';

class AppointWithDoctor extends StatefulWidget {
  final List<dynamic> result;
  const AppointWithDoctor({Key? key, required this.result}) : super(key: key);

  @override
  _AppointWithDoctorState createState() => _AppointWithDoctorState();
}

class _AppointWithDoctorState extends State<AppointWithDoctor> {
  var queryResultSet = [];
  String? userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: widget.result.map((element) {
          return demoTopRatedDoctor(
              element['Patient_Id'],
              element['QR_code_url'],
              element['patient_name'],
              element['hp_name'],
              element['date']);
        }).toList(),
      ),
    );
  }

  Widget demoTopRatedDoctor(
      String name, String code, String patient, String doctor, String date) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {},
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Dear ${patient} your have an appointment with Dr ${doctor}, on the ${date}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Appointment",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 23),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Rounded_button(code),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Rounded_button1(code),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Rounded_button(String code) {
    return InkWell(
      onTap: () {
        showDialog(context, code);
      },
      child: Container(
        height: 80,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(4280564593),
          ),
          child: Center(
              child: Text(
            "View Code",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }

  Rounded_button1(String code) {
    return InkWell(
      onTap: () {
        showDialog(context, code);
      },
      child: Container(
        height: 80,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: Center(
              child: Text(
            "Cancel Appointment",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }

  void showDialog(BuildContext context, String code) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            width: 300,
            child: SizedBox.expand(child: Image.network(code)),
            margin: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
