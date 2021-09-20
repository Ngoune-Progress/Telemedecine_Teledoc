import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teledoc/screen/QRcodegen.dart';
import 'package:uuid/uuid.dart';

import '../variable.dart';

class Appointment_Form extends StatefulWidget {
  final String uid;
  final String name;
  final String date;
  final String fromTime;
  final String toTime;
  const Appointment_Form(
      {Key? key,
      required this.uid,
      required this.name,
      required this.date,
      required this.fromTime,
      required this.toTime})
      : super(key: key);

  @override
  _Appointment_FormState createState() => _Appointment_FormState();
}

class _Appointment_FormState extends State<Appointment_Form> {
  TabController? tabController;
  final _formKey = GlobalKey<FormState>();
  bool isMale = true;
  bool online = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController appointdateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // Center(
              //     child: Text(
              //   "Appointment Form",
              //   style: TextStyle(fontSize: 30, color: Colors.blueGrey),
              // )),

              Container(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Appointment details',
                              style: TextStyle(fontSize: 26),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Divider(
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          Container(
                            child: Column(children: [
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            color: Colors.grey.withOpacity(0.6))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Doctor name : Dr ${widget.name}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            color: Colors.grey.withOpacity(0.6))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Date : ${widget.date}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            color: Colors.grey.withOpacity(0.6))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "From time : ${widget.fromTime}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            color: Colors.grey.withOpacity(0.6))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "From time : ${widget.toTime}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Appointment Form',
                              style: TextStyle(fontSize: 26),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Divider(
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          formField(nameController, "Name", 15),
                          formField(surnameController, "Surname", 10),
                          telField(telephoneController, "Telephone", 9),
                          field(context, dateController, 'Date of Birth'),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ))),
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: !isMale ? Color(4279583578) : Colors.white),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = false;
                          });
                        },
                        child: Icon(
                          Icons.female,
                          color: !isMale ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Female",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isMale ? Color(4279583578) : Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMale = true;
                            });
                          },
                          child: Icon(Icons.male,
                              color: isMale ? Colors.white : Colors.grey)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Male",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              formFielded(descriptionController, "Describe your situation"),
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: !online ? Color(4279583578) : Colors.white),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            online = false;
                          });
                        },
                        child: Icon(
                          Icons.online_prediction,
                          color: !online ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Online",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: online ? Color(4279583578) : Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              online = true;
                            });
                          },
                          child: Icon(Icons.h_mobiledata,
                              color: online ? Colors.white : Colors.grey)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Health Center",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Rounded_button()
            ],
          ),
        ),
      ),
    );
  }

  formField(TextEditingController controller, String labelText, int length) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        maxLength: length,
        controller: controller,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: labelText),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
      ),
    );
  }

  telField(TextEditingController controller, String labelText, int length) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        maxLength: length,
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
            prefix: Text("+237"),
            border: OutlineInputBorder(),
            hintText: labelText),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
      ),
    );
  }

  formFielded(TextEditingController controller, String labelText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        maxLines: 10,
        controller: controller,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: labelText),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
      ),
    );
  }

  Rounded_button() {
    return InkWell(
      onTap: () async {
        final isValid = _formKey.currentState!.validate();

        if (online == true) {
          if (nameController.text != "" &&
              dateController.text != '' &&
              surnameController.text != '' &&
              telephoneController.text != '') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PhoneVerification(
                      date: widget.date,
                      fromTime: widget.fromTime,
                      toTime: widget.toTime,
                      HP_Id: widget.uid,
                      Hp_name: widget.name,
                      name: nameController.text,
                    )));
          }
        } else {
          var doc1;
          var uuid = Uuid().v1();
          String userId = FirebaseAuth.instance.currentUser!.uid;
          await availabilityColllection.get().then(
              (QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
                    if (widget.uid == doc.get('HP_Id')) {
                      await availabilityColllection.doc(doc.id).update({
                        'Patient_Id': FirebaseAuth.instance.currentUser!.uid,
                        'isTaken': true
                      });
                     await  appointmentCollection.doc(doc.id).set({
                        'Hp_Id': widget.uid,
                        'Patient_Id': userId,
                        'Appointment_Id': uuid,
                        'patient_name': nameController.text,
                        "hp_name": widget.name,
                        'date': widget.date,
                        "from_time": widget.fromTime,
                        "toTime": widget.toTime,
                        'QR_code_url': '',
                        // 'password': passwordController.text
                      });

                      Navigator.of(context).pop();
                    }
                  }));
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 100),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(4279583578),
          ),
          child: Center(
              child: Text(
            "Submit",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }

  field(BuildContext context, TextEditingController dateController,
      String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(),
      child: Center(
          child: TextFormField(
        readOnly: true,
        controller: dateController,
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
        decoration:
            InputDecoration(hintText: label, border: OutlineInputBorder()),
        onTap: () async {
          var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          dateController.text = date.toString().substring(0, 10);
        },
      )),
    );
  }
}
