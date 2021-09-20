import 'package:flutter/material.dart';
import 'package:teledoc/VaccinationsTab.dart/vaccine_Form.dart';

class VaccinationForm extends StatefulWidget {
  final String hosName;
  final String hospUid;
  const VaccinationForm(
      {Key? key, required this.hosName, required this.hospUid})
      : super(key: key);

  @override
  _VaccinationFormState createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
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
                Center(
                  child: Container(
                    child: Image.asset("assets/images/cov.png"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "COVID-19 vaccination Campaign",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(4280564593)),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 220,
              color: Color(4293579265),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 13),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: Color(4280564593),
                              )),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              flex: 7,
                              child: Text(
                                "Vaccination appointment",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(4280564593),
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.support_agent,
                                  size: 40, color: Color(4280564593))),
                          Expanded(
                              flex: 7,
                              child: Text(
                                " Answer to your question",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(4280564593),
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 147),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.domain_verification,
                                  size: 40, color: Color(4280564593))),
                          Expanded(
                              flex: 7,
                              child: Text(
                                " Vaccination data",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(4280564593),
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VaccineFormAppoit(
                          hosName: widget.hosName,
                          hosUid: widget.hospUid,
                        )));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(4280564593),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Book a vaccine appointment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
