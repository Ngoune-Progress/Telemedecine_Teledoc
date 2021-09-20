import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({Key? key}) : super(key: key);

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String code = '';

  createCode() {
    setState(() {
      code = Uuid().v1().substring(0, 6);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            "Create Code and share its",
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Code",
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              code,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () {
            createCode();
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(4282318892), Color(4294952249)])),
            child: Center(
              child: Text(
                "Create Code ",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ),
        // Container(
        //   height: 250,
        //   width: double.infinity,
        //   child: Image.asset("assets/images/meet.png"),
        // ),
      ],
    ));
  }
}
