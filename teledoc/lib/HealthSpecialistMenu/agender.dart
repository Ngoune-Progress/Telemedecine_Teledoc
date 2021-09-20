import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teledoc/HealthSpecialistMenu/Utils.dart';
import 'package:teledoc/HealthSpecialistMenu/consultation.dart';
import 'package:teledoc/model/appointment.dart';
import 'package:teledoc/screen/appointment.dart';
import 'package:teledoc/variable.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  var listAppointment = [];
  List<Appointment> s = [];
  @override
  void initState() {
    takeAppointment();

    super.initState();
  }

  Future<void> takeAppointment() async {
    await availabilityColllection
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
              if (FirebaseAuth.instance.currentUser!.uid == doc.get('HP_Id')) {
                setState(() {
                  listAppointment.add(doc.data());
                });
              }
            }));
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Errors'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('No appointment.'),
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

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      dataSource: MeetingDataSource(getAppointments()),
      onTap: (p) async {
        if (p.appointments == null) {
          _showMyDialog('Please select a date when you have an appointment.');
        } else {
          print(Utils.toTime(p.date));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Consultation()));
        }
      },
    );
  }

  List<Appointment> getAppointments() {
    DateTime startTime;
    DateTime endTime;

    List<Appointment> meeting = <Appointment>[];
    listAppointment.map((e) {
      final fmt = DateFormat('EEE, MMM d, ' 'yy');
      DateTime fromDate = fmt.parse(e['from_date']);
      String from_time = e['from_time'];
      startTime = DateTime(
          fromDate.year,
          fromDate.month,
          fromDate.day,
          int.parse(from_time.substring(0, 2)),
          int.parse(from_time.substring(3, 5)),
          0);

      DateTime toDate = fmt.parse(e['to_date']);
      String to_time = e['to_time'];
      endTime = DateTime(
          toDate.year,
          toDate.month,
          toDate.day,
          int.parse(to_time.substring(0, 2)),
          int.parse(to_time.substring(3, 5)),
          0);

      meeting.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: e['title'],
          color: e['isTaken'] == true ? Colors.red : Colors.amber));
    }).toList();

    return meeting;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
