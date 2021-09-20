import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teledoc/HealthSpecialistMenu/Utils.dart';
import 'package:teledoc/screen/appoint_form.dart';
import 'package:teledoc/variable.dart';

class HealthDetailsAgendar extends StatefulWidget {
  final String hpID;
  final String name;
  const HealthDetailsAgendar({Key? key, required this.hpID, required this.name})
      : super(key: key);

  @override
  _HealthDetailsAgendarState createState() => _HealthDetailsAgendarState();
}

class _HealthDetailsAgendarState extends State<HealthDetailsAgendar> {
  var listAppointment = [];
  @override
  void initState() {
    // TODO: implement initState
    takeAppointment();
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
                Text('Error.'),
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
            _showMyDialog('Please select where doctor is free.');
          } else {
            String fromDate = Utils.toDate(p.date);
            String fromTime = Utils.toTime(p.date);
            String toTime = '';
            bool isTaken = false;
            await availabilityColllection
                .get()
                .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
                      if (widget.hpID == doc.get('HP_Id')) {
                        setState(() {
                          toTime = doc.get('to_time');
                          isTaken = doc.get('isTaken');
                        });
                      }
                    }));

            if (isTaken == true) {
              _showMyDialog(
                  "Please doctor already have an appointment at that time");
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Appointment_Form(
                      uid: widget.hpID,
                      name: widget.name,
                      date: fromDate,
                      fromTime: fromTime,
                      toTime: toTime)));
            }
          }
        });
  }

  Future<void> takeAppointment() async {
    await availabilityColllection
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
              if (widget.hpID == doc.get('HP_Id')) {
                setState(() {
                  listAppointment.add(doc.data());
                });
              }
            }));
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
          color: e['isTaken'] == true ? Colors.red : Colors.blue));
    }).toList();

    return meeting;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
