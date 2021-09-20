import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/HealthSpecialistMenu/Hpchat.dart';
import 'package:teledoc/HealthSpecialistMenu/prescription.dart';
import 'package:teledoc/HealthSpecialistMenu/scanner.dart';
import 'package:teledoc/Hp_coference/hp_meeting.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/newsHomeHP.dart';
import 'package:teledoc/variable.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];
  String name = '';
  String? url;

  getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await doctorsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  url = doc.get('image_url');
                  name = doc.get('name');
                });
              }
            }));
  }

  List<SalesData> _chartData = [];
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getCurrentUserProfilePic();
    super.initState();
  }

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
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipOval(
                        child: Image.network(
                          "$url",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      height: 20,
                      width: 150,
                      child: Center(
                        child: Text(
                          '$name',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Agender",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DoctorHomePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Chat",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HpChat()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.schedule,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Appointments",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.file_copy,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Prescription",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Prescription()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.new_releases_rounded,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "News",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => NewsScreen1()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.meeting_room,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Meetings",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VideoConferenceScreenHP()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.qr_code_scanner,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Scannner",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ScannerPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.show_chart,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Analysis",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LineChart()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Account",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue.withOpacity(0.5),
                size: 30,
              ),
              title: Text(
                "Offline",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                try {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        )),
        body: SfCartesianChart(
          title: ChartTitle(text: 'Weekly Consulation analysis'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            AreaSeries<SalesData, double>(
                animationDuration: 700,
                name: 'Consultation',
                color: Color(4280564593),
                dataSource: _chartData,
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.cosultation,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                enableTooltip: true)
          ],
          primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            labelFormat: '{value}K CFA',

            // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
          ),
        ));
  }
}

List<SalesData> getChartData() {
  final List<SalesData> chartData = [
    SalesData(06, 25),
    SalesData(07, 12),
    SalesData(08, 24),
    SalesData(09, 18),
    SalesData(10, 30)
    // SalesData(11, 28),
  ];
  return chartData;
}

class SalesData {
  SalesData(this.year, this.cosultation);
  final double year;
  final double cosultation;
}
