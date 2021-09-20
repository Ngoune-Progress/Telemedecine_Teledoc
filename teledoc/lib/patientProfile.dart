import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teledoc/Menu/chatScreen.dart';
import 'package:teledoc/Menu/videoConferenceScreen.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/news/NewsHome.dart';
import 'package:teledoc/screen/appointment.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/vaccinationPage.dart';
import 'package:teledoc/variable.dart';
import 'package:uuid/uuid.dart';

import 'Menu/ProfileScreen.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({Key? key}) : super(key: key);

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  TextEditingController usernameController = TextEditingController();
  String username = '';
  File? _image;
  final picker = ImagePicker();
  bool dataIsThere = false;
  String? url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

    getCurrentUserProfilePic();
  }

  String? imageurl;
  getCurrentUserProfilePic() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await patientsCollections
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              if (doc.get('uid').toString() == userId) {
                setState(() {
                  url = doc.get('image_url');
                  username = doc.get('username');
                  imageurl = doc.get('image_url');
                });
              }
            }));
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    url = null;
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future getUserData() async {
    DocumentSnapshot userdoc = await patientsCollections
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = userdoc.get('username');
      dataIsThere = true;
    });
  }

  Future editProfile() async {
    var v = Uuid().v1();
    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: "gs://teledoc-5cd0e.appspot.com");
    var storaeRef = storage.ref().child("doctors/$v");
    var uploadTask = storaeRef.putFile(_image!);
    var completeTask = await uploadTask.whenComplete(() => null);
    String downloadUrl = await completeTask.ref.getDownloadURL();
    patientsCollections.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'username': usernameController.text,
      'imageUrl': downloadUrl
      // 'password': passwordController.text
    });
    setState(() {
      username = usernameController.text;
      imageurl = downloadUrl;
    });
    _showMyDialog();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update successful'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Message.'),
                Text('data succesfully update'),
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
    return Scaffold(
      appBar: AppBar(
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
                    child: imageurl == null
                        ? Image.asset("assets/images/prof.png")
                        : ClipOval(
                            child: Image.network(
                              '$imageurl',
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
                        "$username",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.blue.withOpacity(0.5),
              size: 30,
            ),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeMain()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.h_mobiledata,
              color: Colors.blue.withOpacity(0.5),
              size: 30,
            ),
            title: Text(
              "Search Vaccination",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VaccinationSearch()));
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
                  MaterialPageRoute(builder: (context) => PatientChatScreen()));
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => APpointment()));
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
                  MaterialPageRoute(builder: (context) => NewsScreen()));
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
                  builder: (context) => VideoConferenceScreen()));
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
                  MaterialPageRoute(builder: (context) => PatientProfile()));
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      )),
      body: Container(
          child: Stack(alignment: Alignment.center, children: [
        SingleChildScrollView(
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(1.0),
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : url == null
                              ? Image.asset("assets/images/prof.png")
                              : Image.network(
                                  "$url",
                                  fit: BoxFit.cover,
                                )),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 184),
                child: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        height: 400,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Welcome $username",
                                    style: TextStyle(
                                        fontSize: 25,
                                        letterSpacing: 1.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FieldForm("Username", usernameController),
                              SizedBox(
                                height: 10,
                              ),
                              // FieldForm("Phone", usernameController),
                              // SizedBox(
                              //   height: 10,
                              // ),

                              SizedBox(
                                height: 10,
                              ),
                              // FieldForm("Username", usernameController),
                              SizedBox(
                                height: 10,
                              ),
                              // FieldForm("Username", usernameController),
                              Container(
                                height: 55,
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      editProfile();
                                    },
                                    child: Center(
                                      child: Text("Update"),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // CustomPaint(
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //   ),
            //   painter: HeaderCurvedContainer(),
            // ),
          ]),
        ),
      ])),
    );
  }

  FieldForm(String hintext, TextEditingController controller) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintext,
            hintStyle: TextStyle(
                letterSpacing: 2,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
