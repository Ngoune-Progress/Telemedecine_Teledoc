import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teledoc/variable.dart';

class JoinMeeting extends StatefulWidget {
  const JoinMeeting({Key? key}) : super(key: key);

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  bool isVideoMuted = true;
  bool isAudioMuted = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  String username = '';

  Future getUserData() async {
    DocumentSnapshot userdoc = await patientsCollections
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = userdoc.get('username');
    });
  }

  joinMeeting() async {
    try {
      Map<FeatureFlagEnum, bool> featureflags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false
      };
      if (Platform.isAndroid) {
        featureflags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
       } 
      else if (Platform.isIOS) {
        featureflags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
      var option = JitsiMeetingOptions(room: roomController.text)
        ..userDisplayName =
            nameController.text == '' ? username : nameController.text
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureflags);

      await JitsiMeet.joinMeeting(option);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Text(
                "Room Code",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                  controller: roomController,
                  appContext: context,
                  length: 6,
                  autoDisposeControllers: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
                  animationDuration: Duration(microseconds: 300),
                  onChanged: (value) {}),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLength: 15,
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name ( leave if you want your user name )",
                    labelStyle: TextStyle(fontSize: 15)),
              ),
              SizedBox(
                height: 16,
              ),
              CheckboxListTile(
                value: isVideoMuted,
                onChanged: (value) {
                  setState(() {
                    isVideoMuted = value!;
                  });
                },
                title: Text(
                  "Video Muted",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              CheckboxListTile(
                value: isAudioMuted,
                onChanged: (value) {
                  setState(() {
                    isAudioMuted = value!;
                  });
                },
                title: Text(
                  "Audio Muted",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "You can also customize your setting in the meeting",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 48,
                thickness: 2.0,
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  joinMeeting();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Join Meeting",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
