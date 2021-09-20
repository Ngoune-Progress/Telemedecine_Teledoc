import 'package:flutter/material.dart';
import 'package:teledoc/VaccinationsTab.dart/vaccinationForm.dart';

class VaccinationSearchTab extends StatefulWidget {
  final List<dynamic> tempStore;
  const VaccinationSearchTab({Key? key, required this.tempStore})
      : super(key: key);

  @override
  _VaccinationSearchTabState createState() => _VaccinationSearchTabState();
}

class _VaccinationSearchTabState extends State<VaccinationSearchTab> {
  var val;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      val = widget.tempStore;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // StreamBuilder(
                    //     stream: doctorsCollections
                    //         .where('speciality',
                    //             isEqualTo: specialityController.text)
                    //         .snapshots(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot> snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Center(
                    //           child: Container(
                    //             margin: EdgeInsets.only(top: 100),
                    //             height: 50,
                    //             width: 50,
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       }
                    //       return ListView(
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         children: snapshot.data!.docs.map((document) {
                    //           return Center(
                    //               child: demoTopRatedDoctor(
                    //                   document['uid'],
                    //                   document['Address'],
                    //                   document['image_url'],
                    //                   document['name'],
                    //                   document['speciality'],
                    //                   "4.5",
                    //                   context,
                    //                   "2000"));
                    //         }).toList(),
                    //       );
                    //     })

                    val.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "No user found verify your connection",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          )
                        : ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: widget.tempStore.map((element) {
                              return demoTopRatedDoctor(
                                element['uid'],
                                element['name'],
                                element['vaccine'],
                                element['quantity'],
                                context,
                              );
                            }).toList())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget demoCategory(String image) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Center(
        child: Image.asset(image),
      ),
    );
  }

  doctorTiming(String time) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 2),
            child: Center(
              child: Text(
                time,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget demoTopRatedDoctor(
    String uid,
    String name,
    String speciality,
    String quantity,
    BuildContext context,
  ) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => VaccinationForm(
                    hosName: name,
                    hospUid: uid,
                  )));
        },
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
          margin: EdgeInsets.only(
            top: 10,
            bottom: 7,
          ),
          height: 210,
          child: Container(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 110,
                          width: 90,
                          child: Image.asset(
                            "assets/images/Heath.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "$name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "Quantiy ${quantity}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        speciality,
                                        style: TextStyle(
                                            color: Color(0xffababab),
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //       top: 3, left: size.width * 0.25),
                                    //   child: Row(
                                    //     children: [
                                    //       Container(
                                    //         child: Text(
                                    //           "Rating:",
                                    //           style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontFamily: 'Roboto'),
                                    //         ),
                                    //       ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 5),
                                    //   child: Text(
                                    //     "rating",
                                    //     style: TextStyle(
                                    //         fontSize: 12,
                                    //         fontFamily: 'Roboto'),
                                    //   ),
                                    // ),
                                    //   ],
                                    // ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                Divider(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      child: Text(
                    "NEXT AVAILABILITY",
                    style: TextStyle(color: Color(0xffababab), fontSize: 15),
                  )),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      doctorTiming("Mon"),
                      doctorTiming("Tue"),
                      doctorTiming("Wed"),
                      doctorTiming("Thu"),
                      doctorTiming("Fri"),
                      doctorTiming("Sat"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
