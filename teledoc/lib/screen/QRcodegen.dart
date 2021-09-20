import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:teledoc/home/SearchTab.dart';
import 'package:teledoc/screen/appointment.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/variable.dart';
import 'package:uuid/uuid.dart';

class PhoneVerification extends StatefulWidget {
  final String name;
  final String Hp_name;
  final String HP_Id;
  final String date;
  final String fromTime;
  final String toTime;
  const PhoneVerification(
      {Key? key,
      required this.name,
      required this.HP_Id,
      required this.date,
      required this.Hp_name,
      required this.fromTime,
      required this.toTime})
      : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

// Now instantiate FlutterOtp class in order to call sendOtp function

class _PhoneVerificationState extends State<PhoneVerification> {
  File? _imageFile;
  var uuid = Uuid().v1();
  final val1 = Uuid().v1();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // phoneNumber = widget.tel;
    // otp.sendOtp(phoneNumber, " Your TeleDoc verification code is :", minNumber, maxNumber,
    //     countryCode);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/log2.png',
          height: MediaQuery.of(context).size.height / 10,
        ),
        backgroundColor: Color(4279583578),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: Stack(children: [
          isLoading == true
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(),
          SingleChildScrollView(
            child: Column(
              children: [
                Center(),
                SizedBox(
                  height: 30,
                ),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: QrImage(
                      data:
                          'Dr ${widget.Hp_name} you have an Appointment with ${widget.name} on the ${widget.date}  Appointment_Id: ${uuid} from ${widget.fromTime} to ${widget.toTime}',
                      size: 300,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: demoTopRatedDoctor("${widget.name}"))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget demoTopRatedDoctor(String name) {
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
          child: Column(
            children: [
              Text(
                "Dear ${name}",
                style: TextStyle(fontSize: 25),
              ),
              Divider(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This is your QR Code save to fixed appointment demand or cancel to cancel appointment demand ",
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
                        child: Rounded_button(),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Rounded_button_cancel(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Rounded_button_cancel() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeMain()));
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
            "Cancel",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }

  Rounded_button() {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        screenshotController
            .capture(delay: Duration(milliseconds: 10))
            .then((image) {
          //Capture Done
          FirebaseAuth.instance.authStateChanges().listen((user) async {
            if (user != null) {
              // Insert image into firebase storage and add url to firebase firestore
              var userId = user.uid;
              FirebaseStorage storage = FirebaseStorage.instanceFor(
                  bucket: "gs://teledoc-5cd0e.appspot.com");
              var storaeRef = storage.ref().child("QR_Code/$uuid");
              var uploadTask = storaeRef.putData(image!);
              var completeTask = await uploadTask.whenComplete(() => null);
              String downloadUrl = await completeTask.ref.getDownloadURL();
              await availabilityColllection.get().then(
                  (QuerySnapshot snapshot) =>
                      snapshot.docs.forEach((doc) async {
                        if (widget.HP_Id == doc.get('HP_Id')) {
                          await availabilityColllection.doc(doc.id).update({
                            'Patient_Id':
                                FirebaseAuth.instance.currentUser!.uid,
                            'isTaken': true
                          });
                        }
                      }));
              appointmentCollection.doc().set({
                'Hp_Id': widget.HP_Id,
                'Patient_Id': userId,
                'Appointment_Id': uuid,
                'atHos': true,
                'patient_name': widget.name,
                "hp_name": widget.Hp_name,
                'date': widget.date,
                "from_time": widget.fromTime,
                "toTime": widget.toTime,
                'QR_code_url': downloadUrl,
                // 'password': passwordController.text
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => APpointment()));
            }
          });
        }).catchError((onError) {});
      },
      child: Container(
        height: 80,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(4279583578),
          ),
          child: Center(
              child: Text(
            "Save",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
