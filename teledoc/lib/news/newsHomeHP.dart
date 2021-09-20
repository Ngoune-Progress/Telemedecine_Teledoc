import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/HealthSpecialistMenu/Hpchat.dart';
import 'package:teledoc/HealthSpecialistMenu/chart.dart';
import 'package:teledoc/HealthSpecialistMenu/prescription.dart';
import 'package:teledoc/HealthSpecialistMenu/scanner.dart';
import 'package:teledoc/Hp_coference/hp_meeting.dart';
import 'package:teledoc/Menu/ProfileScreen.dart';
import 'package:teledoc/Menu/chatScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/model/News.dart';
import 'package:teledoc/network/api_request.dart';
import 'package:teledoc/news/infoDetails.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../variable.dart';

class NewsScreen1 extends StatefulWidget {
  const NewsScreen1({Key? key}) : super(key: key);

  @override
  _NewsScreenState1 createState() => _NewsScreenState1();
}

class _NewsScreenState1 extends State<NewsScreen1>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> tabs = <Tab>[
    new Tab(
      text: 'General',
    ),
    new Tab(
      text: 'Technology',
    ),
    new Tab(
      text: 'Sports',
    ),
    new Tab(
      text: 'Business',
    ),
    new Tab(
      text: 'Entertainement',
    ),
    new Tab(
      text: 'Health ',
    )
  ];
  String? url;
  String? name;
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

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserProfilePic();
    _tabController = new TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/detail':
            return PageTransition(
                child: InfoDetailPage(),
                type: PageTransitionType.fade,
                settings: settings);
            break;
          default:
            return null;
        }
      },
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
                indicatorHeight: 30.0,
                indicatorColor: Colors.white,
                tabBarIndicatorSize: TabBarIndicatorSize.tab),
            tabs: tabs,
            controller: _tabController,
          ),
          elevation: 0.0,
          backgroundColor: Colors.blue,
          title: Image.asset(
            'assets/images/log2.png',
            height: MediaQuery.of(context).size.height / 10,
          ),
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
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((tab) {
            return FutureBuilder(
                future: fetchNewsByCategory("${tab.text}"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    var newsList = snapshot.data as News;
                    //Select top 10,
                    //If length > 10 we will get from 0~10
                    //If length < 10 we will get from 0~x
                    //If lenth =0 we will get from 0
                    var sliderList = newsList.articles != null
                        ? newsList.articles!.length > 10
                            ? newsList.articles!.getRange(0, 10).toList()
                            : newsList.articles!
                                .take(newsList.articles!.length)
                                .toList()
                        : [];
                    // Select article except top 10
                    var contenList = newsList.articles != null
                        ? newsList.articles!.length > 10
                            ? newsList.articles!
                                .getRange(11, newsList.articles!.length - 1)
                                .toList()
                            : []
                        : [];
                    return SafeArea(
                        child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8),
                          items: sliderList.map((item) {
                            return Builder(builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  context.read(urlState).state = item.url;
                                  Navigator.pushNamed(context, '/detail');
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        '${item.urlToImage}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          color: Colors.blue,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              '${item.title}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                          }).toList(),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Trending",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: contenList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read(urlState).state =
                                          contenList[index].url;
                                      Navigator.pushNamed(context, '/detail');
                                    },
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${contenList[index].urlToImage}',
                                          fit: BoxFit.fitWidth,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      title: Text(
                                        '${contenList[index].title}',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      subtitle: Text(
                                        '${contenList[index].publishedAt}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    ));
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                });
          }).toList(),
        ),
      ),
    );
  }
}
