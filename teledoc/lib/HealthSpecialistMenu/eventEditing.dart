import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/HealthSpecialistMenu/Utils.dart';
import 'package:teledoc/HealthSpecialistMenu/agender.dart';
import 'package:teledoc/eventProvider.dart';
import 'package:teledoc/model/Event.dart';
import 'package:teledoc/variable.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;
  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  TextEditingController titleController = TextEditingController();
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  @override
  void initState() {
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(minutes: 30));
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DoctorHomePage()));
              },
              icon: Icon(Icons.close));
        }),
        actions: buildEditingAction(),
      ),
      body: Stack(children: [
        isloading == true
            ? Align(
                alignment: Alignment.center,
                child: Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Container(),
        SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: buildTitle()),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: buildDateTimePicker())
              ],
            ),
          ),
        ),
      ]),
    );

    // ignore: unused_element
    // ignore: dead_code
  }

  List<Widget> buildEditingAction() => [
        ElevatedButton.icon(
            onPressed: () {
              saveFrom();
            },
            icon: Icon(Icons.done),
            label: Text('Save'))
      ];

  Widget buildTitle() {
    return TextFormField(
      controller: titleController,
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Title',
      ),
      onFieldSubmitted: (_) {
        saveFrom();
      },
      validator: (title) =>
          title != null && title.isEmpty ? 'Title cannot be empty' : null,
    );
  }

  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );
  Widget buildFrom() => buildHeader(
        header: "From",
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                    text: Utils.toDate(fromDate),
                    onClicked: () {
                      pickFromDateTime(pickDate: true);
                    })),
            Expanded(
                child: buildDropdownField(
                    text: Utils.toTime(fromDate),
                    onClicked: () => pickFromDateTime(pickDate: false)))
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate = date;
      toDate = date.add(Duration(minutes: 30));
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    DateTime today = DateTime.now();
    int currentDay = today.weekday;
    DateTime _firstDayOfTheweek =
        today.subtract(new Duration(days: currentDay));

    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 7)));
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      if (date.day == DateTime.now().day) {
        return DateTime.now();
      }
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      int timeT = ((timeOfDay.hour * 60) + timeOfDay.minute) * 60;
      double fromT = ((DateTime.now().hour * 60) + DateTime.now().minute) * 60;
      if (fromDate.hour == timeOfDay.hour) {
        _showMyDialog('Your from time cant be less the than the present time');
      }
      if (date.isAfter(DateTime.now())) {
        return date.add(time);
      } else {
        if (timeT < fromT) {
          // bool check = true;
          print('Please enter correct time');

          _showMyDialog(
              'Your from time cant be less the than the present time');

          return fromDate;
        } else {
          return date.add(time);
        }
      }
    }
  }

  Widget buildTo() => buildHeader(
        header: "To",
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                    text: Utils.toDate(toDate),
                    onClicked: () {
                      pickToDateTime(pickDate: true);
                    })),
            Expanded(
                child: buildDropdownField(
                    text: Utils.toTime(toDate),
                    onClicked: () {
                      pickToDateTime(pickDate: false);
                    }))
          ],
        ),
      );
  Widget buildDropdownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
          title: Text(text),
          trailing: Icon(
            Icons.arrow_drop_down,
          ),
          onTap: onClicked);

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          child
        ],
      );

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickTDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    if (date == fromDate) {
      setState(() {
        toDate = date.add(Duration(minutes: 30));
      });
    } else {
      setState(() {
        toDate = date;
      });
    }
  }

  Future<DateTime?> pickTDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: fromDate,
          lastDate: fromDate);
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      int timeT = ((timeOfDay.hour * 60) + timeOfDay.minute) * 60;
      int fromT = ((fromDate.hour * 60) + fromDate.minute) * 60;
      if (timeT == fromT) {
        _showMyDialog('Your to time cant be equal to from Time');
        return fromDate;
      }
      if (timeT < fromT) {
        // bool check = true;
        print('Please enter correct time');
        _showMyDialog('Your to time cant be less than from time');
        return fromDate;
      } else {
        return date.add(time);
      }
    }
  }

  Future saveFrom() async {
    bool check = false;
    setState(() {
      isloading = true;
    });
    final isValid = _formKey.currentState!.validate();
    await availabilityColllection
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
              if (FirebaseAuth.instance.currentUser!.uid == doc.get('HP_Id')) {
                if (doc.get('from_date') == Utils.toDate(fromDate) &&
                    doc.get('from_time') == Utils.toTime(fromDate) &&
                    doc.get('to_time') == Utils.toTime(toDate))
                  setState(() {
                    check = true;
                  });
              }
            }));
    if (check == true) {
      _showMyDialog('Date Already store in database');

      isloading = false;
    }

    if (isValid && check == false) {
      await availabilityColllection.doc().set({
        "from_date": Utils.toDate(fromDate),
        "to_date": Utils.toDate(toDate),
        "from_time": Utils.toTime(fromDate),
        "to_time": Utils.toTime(toDate),
        "title": titleController.text,
        "HP_Id": FirebaseAuth.instance.currentUser!.uid,
        "isTaken": false,
        "Patient_Id": ''
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DoctorHomePage()));
    }
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

  Future<void> showDialog1(BuildContext context, String text) async {
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
            width: 310,
            child: SizedBox.expand(
                child: Container(
              child: Container(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "${text}",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Image.asset(
                      'assets/images/cross.png',
                      height: 250,
                    ))
                  ],
                ),
              ),
            )),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
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
