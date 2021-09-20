import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/eventProvider.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/introAuthScreen.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/variable.dart';

var globalContext;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSigne = false;
  var check1 = '';
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      var userId = FirebaseAuth.instance.currentUser!.uid;

      usersCollection
          .get()
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
                if (doc.get('id') == userId) {
                  setState(() {
                    check1 = doc.get('isDoctor');
                  });
                }
              }));

      setState(() {
        if (user != null) {
          isSigne = true;
        } else {
          isSigne = false;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tele-Doc',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isSigne == false
            ? IntroAuthScreen()
            : NavigationPage(
                isDoctor: check1,
              ),
      ),
    );
  }
}

class NavigationPage extends StatefulWidget {
  final String isDoctor;
  const NavigationPage({
    Key? key,
    required this.isDoctor,
  }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.isDoctor != ''
            ? (widget.isDoctor == 'no' ? HomeMain() : DoctorHomePage())
            : Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ));
  }
}
