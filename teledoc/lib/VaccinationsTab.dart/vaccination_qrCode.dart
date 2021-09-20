import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:teledoc/screen/VaccinationSearch.dart';
import 'package:teledoc/screen/vaccinationPage.dart';
import 'package:teledoc/variable.dart';
import 'package:uuid/uuid.dart';

class VaccinQrCode extends StatefulWidget {
  final String hosp_id;
  final String host_name;
  final String date;
  final String p_name;

  const VaccinQrCode(
      {Key? key,
      required this.hosp_id,
      required this.host_name,
      required this.date,
      required this.p_name})
      : super(key: key);

  @override
  _VaccinQrCodeState createState() => _VaccinQrCodeState();
}

class _VaccinQrCodeState extends State<VaccinQrCode> {
  File? _imageFile;
  var uuid = Uuid();
  final val1 = Uuid().v1();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/log2.png',
          height: MediaQuery.of(context).size.height / 10,
        ),
        backgroundColor: Color(4280564593),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
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
                        'Vaccine Appointment  at ${widget.host_name} on the ${widget.date} by ${widget.p_name}',
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
                  child: demoTopRatedDoctor("${widget.p_name}"))
            ],
          ),
        ),
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
          height: 250,
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
                  "This is your QR Code save to fixed appointment Or cancel to cancel appointment",
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
              )
            ],
          ),
        ));
  }

  Rounded_button_cancel() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => VaccinationSearch()));
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
        screenshotController
            .capture(delay: Duration(milliseconds: 10))
            .then((image) {
          final val = uuid.v1();
          //Capture Done
          FirebaseAuth.instance.authStateChanges().listen((user) async {
            if (user != null) {
              // Insert image into firebase storage and add url to firebase firestore
              var userId = user.uid;
              FirebaseStorage storage = FirebaseStorage.instanceFor(
                  bucket: "gs://teledoc-5cd0e.appspot.com");
              var storaeRef = storage.ref().child("QR_Code/$val");
              var uploadTask = storaeRef.putData(image!);
              var completeTask = await uploadTask.whenComplete(() => null);
              String downloadUrl = await completeTask.ref.getDownloadURL();
              vaccineCollection.doc().set({
                'Hospital_Id': widget.hosp_id,
                'date': widget.date,
                'hospital_name': widget.host_name,
                'Patient_Id': userId,

                'QR_code_url': downloadUrl,
                // 'password': passwordController.text
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VaccinationSearch()));
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
            color: Color(4280564593),
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
