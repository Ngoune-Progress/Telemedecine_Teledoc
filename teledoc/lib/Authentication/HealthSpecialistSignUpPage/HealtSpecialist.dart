import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/repository/storage.dart';
import 'package:teledoc/variable.dart';
import 'package:uuid/uuid.dart';

class HealthSpecialistSignUpPage extends StatefulWidget {
  const HealthSpecialistSignUpPage({Key? key}) : super(key: key);

  @override
  _HealthSpecialistSignUpPageState createState() =>
      _HealthSpecialistSignUpPageState();
}

class _HealthSpecialistSignUpPageState
    extends State<HealthSpecialistSignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController noOfHospitalController = TextEditingController();
  TextEditingController hosController = TextEditingController();
  // TextEditingController experienceController = TextEditingController();
  //for date picker
  TextEditingController dateController = TextEditingController();

  // Position variable
  Position? _currentPosition;
  Map<String, double>? userLocation;
  String dropdownValue = 'Dentist';
  String _currentAddress = "";
  String? downloadUrl;
// Get user Current Location
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      print(e);
    });
  }

  Future<String> store(file) async {
    var v = Uuid().v1();
    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: "gs://teledoc-5cd0e.appspot.com");
    var storaeRef1 = storage.ref().child('Documents/$v');
    var uploadTask1 =
        storaeRef1.putFile(file!, SettableMetadata(contentType: 'pdf'));
    var completeTask1 = await uploadTask1.whenComplete(() => null);
    String downloadUrl1 = await completeTask1.ref.getDownloadURL();
    return downloadUrl1;
  }

  var list = [];
  File? file;
  var fileBytes;
  String? fileName = '';
  var fileBytes1;
  String? fileName1 = '';
  var fileBytes2;
  String? fileName2 = '';
  var fileBytes3;
  String? fileName3 = '';
  String downloadUrl1 = '';
  String? downloadUrl2 = '';
  String? downloadUrl3 = '';
  String? downloadUrl4 = '';
  Future getPdfAndUpload() async {
    var rng = new Random();

    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (file != null) {
      final path = file.files.single.path!;
      setState(() {
        fileBytes = File(path);
        fileName = file.files.first.name;
      });
      final t = await store(fileBytes);
      setState(() {
        downloadUrl1 = t;
      });
    }

    // savePdf(file.readAsBytesSync(), fileName);
  }

  int i = 1;

  Future getPdfAndUpload1() async {
    var rng = new Random();

    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (file != null) {
      final path = file.files.single.path!;
      setState(() {
        fileBytes1 = File(path);
        fileName1 = file.files.first.name;
      });
      final t = await store(fileBytes1);
      setState(() {
        downloadUrl2 = t;
      });
    }

    // savePdf(file.readAsBytesSync(), fileName);
  }

  Future getPdfAndUpload2() async {
    var rng = new Random();

    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (file != null) {
      final path = file.files.single.path!;
      setState(() {
        fileBytes2 = File(path);
        fileName2 = file.files.first.name;
      });
      final t = await store(fileBytes2);
      setState(() {
        downloadUrl3 = t;
      });
    }

    // savePdf(file.readAsBytesSync(), fileName);
  }

  Future getPdfAndUpload3() async {
    var rng = new Random();

    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (file != null) {
      final path = file.files.single.path!;
      setState(() {
        fileBytes3 = File(path);
        fileName3 = file.files.first.name;
      });
      final t = await store(fileBytes3);
      setState(() {
        downloadUrl4 = t;
      });
    }

    // savePdf(file.readAsBytesSync(), fileName);
  }

//Changing lonitude and latitude location to real address
  _getAddressFromLatLng(Position position) async {
    //gecoding
    var places =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (places != null && places.isNotEmpty) {
      final Placemark place = places.first;
      setState(() {
        _currentAddress =
            "${place.country},${place.subAdministrativeArea},${place.street}";
      });
    }
  }

  Future<void> _verfifyCredentials(TextEditingController emailLogin,
      TextEditingController passwordLogin, BuildContext context) async {
    bool check = false;
    String IsDoctor = '';

    //await

    await usersCollection
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
              if (doc.get('email').toString() == emailLogin.text &&
                  doc.get('password').toString() == passwordLogin.text) {
                setState(() {
                  check = true;
                  IsDoctor = doc.get('state');
                });
              }
            }));

    if (check == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NavigationPage(isDoctor: IsDoctor)));
    } else {
      showDialog1(context);
      // FirebaseAuth.instance.signOut();

    }
  }

  File? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  // Get image from galery
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              // Head with image
              Stack(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(color: Color(4279583578)),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                            child: _image == null
                                ? Image.asset(
                                    "assets/images/prof.png",
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70, top: 185),
                    child: Padding(
                        padding: EdgeInsets.only(left: 184),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: Icon(
                              Icons.camera,
                              color: Color(4279583578),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Heading textfield
              Text(
                "Fill the empty fields",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Divider(
                  height: 10,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //Personal Information
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 320,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero,
                          color: Colors.grey)
                    ]),
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Personal Information",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: FieldForm("Name", nameController, false)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: field(context, dateController)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: FieldForm("Email", emailController, false)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              FieldForm("Password", passwordController, true))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              // Document Mode
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 405,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero,
                          color: Colors.grey)
                    ]),
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Documents",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("University Diploma:"),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'File name: ${fileName}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.upload_file),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        getPdfAndUpload();
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("Medical License:"),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'File name: ${fileName1}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.upload_file),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        getPdfAndUpload1();
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("Cameroun Medical Council card:"),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'File name: ${fileName2}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.upload_file),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        getPdfAndUpload2();
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("Id Card:"),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'File name: ${fileName3}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.upload_file),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        getPdfAndUpload3();
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 190,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero,
                          color: Colors.grey)
                    ]),
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Hospital ",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: FieldForm("No of hospital you work",
                              noOfHospitalController, false)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: TextField(
                                    controller: hosController,
                                    maxLines: 1,
                                    autofocus: false,
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Hos:${i}"),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        // _getCurrentLocation();
                                        if (noOfHospitalController
                                            .text.isNotEmpty) {
                                          if (i <=
                                              int.parse(noOfHospitalController
                                                  .text)) {
                                            setState(() {
                                              if (hosController
                                                  .text.isNotEmpty) {
                                                list.add(hosController);
                                                i++;
                                              } else {
                                                _showMyDialog();
                                              }
                                            });
                                          }
                                        } else {
                                          _showMyDialog();
                                        }
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Experience
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero,
                          color: Colors.grey)
                    ]),
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Experience",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                            elevation: 4,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(4279583578),
                                  borderRadius: BorderRadius.circular(1)),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  value: dropdownValue,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  dropdownColor: Color(4279583578),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25),

                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Dentist',
                                    'Dermatologiste',
                                    'Octamologiste',
                                    'Cadiologiste',
                                    'Pediatrician',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  // Put widgets in the drop down menu here
                                ),
                              ),
                            )),
                      ),

                      // FieldForm(
                      //     "Speciality", specialityController, false)

                      SizedBox(
                        height: 10,
                      ),
                      // Location form
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: Row(children: [
                            Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: TextField(
                                    maxLines: 1,
                                    autofocus: false,
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "${_currentAddress}"),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4279583578),
                                      borderRadius: BorderRadius.circular(1)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.my_location),
                                      color: Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        _getCurrentLocation();
                                      },
                                    ),
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: FieldForm(
                              "Years of Work", experienceController, false))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Register button
              Container(
                child: RegisterButton(context, size, nameController,
                    dateController, emailController, passwordController),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Material field(BuildContext context, TextEditingController dateController) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      child: Container(
        decoration: BoxDecoration(),
        child: Center(
            child: TextField(
          readOnly: true,
          controller: dateController,
          decoration: InputDecoration(
              hintText: 'Date of Birth',
              hintStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              border: OutlineInputBorder(borderSide: BorderSide.none)),
          onTap: () async {
            var date = await showDatePicker(
                context: context,
                initialDate: DateTime(2003),
                firstDate: DateTime(1940),
                lastDate: DateTime(2009));
            dateController.text = date.toString().substring(0, 10);
          },
        )),
      ),
    );
  }

  Future onSubmit() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
  }

  FieldForm(String hintext, TextEditingController controller, bool ispass) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      child: TextField(
        obscureText: ispass,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintext,
            hintStyle:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  void showDialog1(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
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

  Future<void> _showMyDialog1() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Loading'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please Wait ....'),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
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
                Text('Please fill all the field  correctly'),
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

  InkWell RegisterButton(
    BuildContext context,
    Size size,
    TextEditingController nameController,
    TextEditingController dateController,
    TextEditingController emailController,
    TextEditingController passwordController,
    // File? _image
  ) {
    return InkWell(
      onTap: () {
        print(1);

        if (_image == null ||
            nameController.text.isEmpty ||
            dateController.text.isEmpty ||
            emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            noOfHospitalController.text.isEmpty ||
            fileBytes == null ||
            fileBytes1 == null ||
            fileBytes2 == null ||
            fileBytes3 == null) {
          // print(1);
          _showMyDialog();
        } else {
          try {
            _showMyDialog1();
            print(2);
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text)
                .then((signUser) async => {
                      doctorsCollections.doc(signUser.user!.uid).set({
                        'name': nameController.text,
                        'uid': signUser.user!.uid,
                        'DOB': dateController.text,
                        'email': emailController.text.trim(),
                        'password': passwordController.text.trim(),
                        'speciality': dropdownValue.toLowerCase(),
                        'Year-of-work': experienceController.text,
                        'searchKey': dropdownValue[0].toLowerCase(),
                        // ignore: unnecessary_null_comparison
                        'Address': _currentAddress,
                        'lat': "${_currentPosition!.latitude}",
                        'lon': "${_currentPosition!.longitude}",

                        'image_url': '',
                        'university_diploma_url': '',
                        'Medical_License': '',
                        'Medical_council_card': '',
                        'id_card': '',
                      }),
                      usersCollection.doc(signUser.user!.uid).set({
                        'id': signUser.user!.uid,
                        'firstName': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'password': passwordController.text.trim(),
                        'isDoctor': 'yes',
                        'imageUrl': '',
                        'roles': 'd',
                      }),
                    });

            FirebaseAuth.instance.authStateChanges().listen((user) async {
              if (user != null) {
                // Insert image into firebase storage and add url to firebase firestore

                var userId = user.uid;
                print("heoo");
                FirebaseStorage storage = FirebaseStorage.instanceFor(
                    bucket: "gs://teledoc-5cd0e.appspot.com");
                // var storaeRef1 =
                //     storage.ref().child('Hp_Univeristy_diploma/$userId');
                // var uploadTask1 = storaeRef1.putFile(
                //     fileBytes!, SettableMetadata(contentType: 'pdf'));
                // var completeTask1 = await uploadTask1.whenComplete(() => null);
                // String downloadUrl1 = await completeTask1.ref.getDownloadURL();

                // var storaeRef2 = storage.ref().child('Medical_license/$userId');
                // var uploadTask2 = storaeRef2.putFile(
                //     fileBytes1!, SettableMetadata(contentType: 'pdf'));
                // var completeTask2 = await uploadTask2.whenComplete(() => null);
                // String downloadUrl2 = await completeTask2.ref.getDownloadURL();

                // var storaeRef3 =
                //     storage.ref().child('Medical_council_card/$userId');
                // var uploadTask3 = storaeRef3.putFile(
                //     fileBytes2!, SettableMetadata(contentType: 'pdf'));
                // var completeTask3 = await uploadTask3.whenComplete(() => null);
                // String downloadUrl3 = await completeTask3.ref.getDownloadURL();

                // var storaeRef4 = storage.ref().child('id_card/$userId');
                // var uploadTask4 = storaeRef4.putFile(
                //     fileBytes3!, SettableMetadata(contentType: 'pdf'));
                // var completeTask4 = await uploadTask4.whenComplete(() => null);
                // String downloadUrl4 = await completeTask4.ref.getDownloadURL();

                var storaeRef = storage.ref().child("doctors/$userId");
                var uploadTask = storaeRef.putFile(_image!);
                var completeTask = await uploadTask.whenComplete(() => null);
                String downloadUrl = await completeTask.ref.getDownloadURL();

                doctorsCollections
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  'image_url': downloadUrl,
                  'university_diploma_url': downloadUrl1,
                  'Medical_License': downloadUrl2,
                  'Medical_council_card': downloadUrl3,
                  'id_card': downloadUrl4,

                  // 'password': passwordController.text
                });
                usersCollection
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  'imageUrl': downloadUrl,
                });
                String IsDoctor = '';

                //await
                bool check = false;
                usersCollection.get().then(
                    (QuerySnapshot snapshot) => snapshot.docs.forEach((doc) {
                          if (doc.get('email').toString() ==
                                  emailController.text.trim() &&
                              doc.get('password').toString() ==
                                  passwordController.text.trim()) {
                            setState(() {
                              IsDoctor = doc.get('isDoctor');
                              check = true;
                            });
                          }
                        }));

                if (check == true) {
                  isLoading = false;

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          NavigationPage(isDoctor: IsDoctor)));
                }
              }
            });
          } catch (e) {}
        }
        // Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            color: Color(4279583578), borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
