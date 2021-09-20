import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teledoc/VaccinationsTab.dart/vaccination_qrCode.dart';

class VaccineFormAppoit extends StatefulWidget {
  final String hosName;
  final String hosUid;
  const VaccineFormAppoit(
      {Key? key, required this.hosName, required this.hosUid})
      : super(key: key);

  @override
  _VaccineFormAppoitState createState() => _VaccineFormAppoitState();
}

class _VaccineFormAppoitState extends State<VaccineFormAppoit> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: -0.0,
        title: Image.asset(
          'assets/images/log2.png',
          height: MediaQuery.of(context).size.height / 10,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
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
        backgroundColor: Color(4280564593),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 170,
                  decoration: BoxDecoration(
                    color: Color(4280564593),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                Container(
                  height: 100,
                  child: Center(
                      child: Image.asset(
                    "assets/images/Heath.png",
                  )),
                ),
                Center(
                  child: Container(
                    width: 500,
                    child: Image.asset("assets/images/vaccinate.png"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Center(
                child: Text(
                  "Please field the vaccination appointment form",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Color(4280564593)),
                ),
              ),
            ),
            Divider(
              height: 10,
              thickness: 1.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    child: Center(
                        child: Image.asset(
                      "assets/images/Heath.png",
                    )),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 0.1,
                                  color: Colors.grey.shade300)
                            ]),
                        child: Center(
                            child: Text(
                          "At ${widget.hosName}",
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        formField(nameController, "Name", 15),
                        formField(surnameController, "Surname", 10),
                        telField(telephoneController, "Telephone", 9),
                        field(context, dateController),
                        formField(nameController, "Name", 15),
                        formField(nameController, "Name", 15),
                        formField(nameController, "Name", 15),
                      ],
                    ))),
            Rounded_button()
          ],
        ),
      ),
    );
  }

  formField(TextEditingController controller, String labelText, int length) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 5),
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
      padding: EdgeInsets.only(top: 5),
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
      padding: EdgeInsets.only(top: 5),
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
      onTap: () {
        final isValid = _formKey.currentState!.validate();

        if (nameController.text != "" &&
            dateController.text != '' &&
            surnameController.text != '' &&
            telephoneController.text != '') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => VaccinQrCode(hosp_id: widget.hosUid,host_name: widget.hosName,date: dateController.text,p_name: nameController.text,)));
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
            color: Color(4280564593),
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

  field(BuildContext context, TextEditingController dateController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 5, bottom: 10),
      decoration: BoxDecoration(),
      child: Center(
          child: TextFormField(
        readOnly: true,
        controller: dateController,
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Field cannot be empty' : null,
        decoration: InputDecoration(
            hintText: 'Date of Birth', border: OutlineInputBorder()),
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
