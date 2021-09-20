import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teledoc/Authentication/HealthSpecialistSignUpPage/HealtSpecialist.dart';
import 'package:teledoc/HealthSpecialistMenu/Home.dart';
import 'package:teledoc/main.dart';
import 'package:teledoc/screen/homeMain.dart';
import 'package:teledoc/screen/searchPage.dart';
import 'package:teledoc/variable.dart';

class LoginAndSignUpPage extends StatefulWidget {
  const LoginAndSignUpPage({Key? key}) : super(key: key);

  @override
  _LoginAndSignUpPageState createState() => _LoginAndSignUpPageState();
}

class _LoginAndSignUpPageState extends State<LoginAndSignUpPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailLogin = TextEditingController();
  TextEditingController passwordLogin = TextEditingController();
  TextEditingController usernameRegister = TextEditingController();
  TextEditingController emailRegister = TextEditingController();
  TextEditingController passwordRegister = TextEditingController();
  bool isLoading = false;
  bool isLogin = true;
  bool isDoctor = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);
  bool isAuth = false;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // true for doctor  ,, false for patient
    Size size = MediaQuery.of(context).size;
    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determin if keyboard is open or not
    double defaultRegisterSize = size.height - (size.height * 0.1);
    double defaultLoginSize = size.height - (size.height * 0.2);
    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return Scaffold(
      body: Stack(
        children: [
          // isLoading == true
          //     ? Container(
          //         child: CircularProgressIndicator(),
          //       )
          //     : Container(),
          // Lets add some decorations
          // Positioned(
          //   top: 100,
          //   right: -50,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Color(4289582335)),
          //   ),
          // ),
          // Positioned(
          //   top: -20,
          //   left: -22,
          //   child: Container(
          //     width: 150,
          //     height: 150,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(100),
          //         color: Color(4289582335)),
          //   ),
          // ),

          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: size.width,
                  height: size.height * 0.1,
                  alignment: Alignment.bottomCenter,
                  child: !isLogin
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              animationController.reverse();
                              isLogin = !isLogin;
                            });
                          },
                          icon: Icon(Icons.close))
                      : null),
            ),
          ),
          isLoading == true
              ? Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
          // Login Form
          Container(
            child: SingleChildScrollView(
              child: Column(children: [
                AnimatedOpacity(
                  opacity: isLogin ? 1.0 : 0.0,
                  duration: animationDuration * 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: isLogin
                          ? Container(
                              margin: EdgeInsets.only(top: 30),
                              width: size.width,
                              height: defaultLoginSize,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //4285097451
                                    Image.asset(
                                      "assets/images/1.png",
                                      height: 150,
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Image.asset(
                                      "assets/images/doctor.png",
                                      height: size.height * 0.5,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RoundedLoginInput(
                                        size,
                                        false,
                                        "Email",
                                        Icons.email,
                                        emailLogin,
                                        TextInputType.emailAddress),
                                    RoundedLoginInput(
                                        size,
                                        true,
                                        "Password",
                                        Icons.password,
                                        passwordLogin,
                                        TextInputType.visiblePassword),

                                    LoginButton(size),
                                  ],
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // Register
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }
              //returning emptyContainer to hide the widget
              return Container();
            },
          ),
          Visibility(
            visible: !isLogin,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/log2.png",
                          height: size.height * 0.11,
                        ),
                        Image.asset(
                          "assets/images/test2.png",
                          height: size.height * 0.25,
                        ),
                        RoundedRegisterInput(size, false, "Username",
                            Icons.face, usernameRegister),
                        RoundedRegisterInput(
                            size, false, "Email", Icons.email, emailRegister),
                        RoundedRegisterInput(size, true, "Password",
                            Icons.password, passwordRegister),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                        !isDoctor ? Colors.blue : Colors.white),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isDoctor = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.sick,
                                    color:
                                        !isDoctor ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Patient",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 40),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                        isDoctor ? Colors.blue : Colors.white),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDoctor = true;
                                      });
                                    },
                                    child: Icon(Icons.healing_sharp,
                                        color: isDoctor
                                            ? Colors.white
                                            : Colors.grey)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Doctor",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RegisterButton(size)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: Color(4279583578)),
        alignment: Alignment.center,
        child: isLogin
            ? GestureDetector(
                onTap: () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: isLogin
                    ? Text(
                        "Don't have an account?  Sign up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )
                    : null,
              )
            : null,
      ),
    );
  }

  InkWell LoginButton(
    Size size,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        // onSubmit();
        if (emailLogin.text.isEmpty || passwordLogin.text.isEmpty) {
          SnackBar snackBar =
              SnackBar(content: Text("Please field the empty field"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          isLoading = false;
        } else {
          try {
            _verfifyCredentials(emailLogin, passwordLogin, context);
            FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailLogin.text, password: passwordLogin.text);
            FirebaseAuth.instance.authStateChanges().listen((user) async {
              if (user != null) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyApp()));
              } else {
                isLoading = false;
              }
            });
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            // print(e);
            _showMyDialog('An error occur please verify internet connection');
          }
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.99),
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          "LOGIN",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
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

  InkWell RegisterButton(Size size) {
    return InkWell(
      onTap: () {
        if (isDoctor == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HealthSpecialistSignUpPage()));
        } else {
          try {
            setState(() {
              isLoading = true;
            });
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailRegister.text, password: passwordRegister.text)
                .then((signUser) => {
                      patientsCollections.doc(signUser.user!.uid).set({
                        'uid': signUser.user!.uid,
                        'username': usernameRegister.text,
                        'email': emailRegister.text,
                        'password': passwordRegister.text,
                        'patient': !isDoctor,
                        'imageUrl': ''
                      }),
                      usersCollection.doc(signUser.user!.uid).set({
                        'id': signUser.user!.uid,
                        'firstName': usernameRegister.text.trim(),
                        'email': emailRegister.text.trim(),
                        'password': passwordRegister.text.trim(),
                        'isDoctor': 'no',
                        'roles': 'p',
                        'imageUrl':
                            'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'
                      }),
                      _verfifyCredentials(emailLogin, passwordLogin, context),
                      FirebaseAuth.instance.authStateChanges().listen((user) {
                        if (user != null) {
                          // showDialog(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          _showMyDialog(
                              'An error occur please verify internet connection');
                        }
                      })
                    });
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            print(e);
            _showMyDialog('An error occur please verify internet connection');

            // showDialog(context);
            // var snackBar = SnackBar(content: Text(e.toString()));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.99),
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          "SIGNUP",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
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

  // ignore: non_constant_identifier_names
  Container RoundedLoginInput(
      Size size,
      bool pass,
      String hintText,
      IconData iconData,
      TextEditingController control,
      TextInputType textInputType) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isLogin ? Colors.blue.withOpacity(0.3) : Colors.white),
      child: TextField(
        keyboardType: textInputType,
        controller: control,
        obscureText: pass,
        cursorColor: Colors.blue.withOpacity(0.5),
        decoration: InputDecoration(
            icon: Icon(
              iconData,
              color: isLogin
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.blue.withOpacity(0.99),
            ),
            hintText: hintText,
            border: InputBorder.none),
      ),
    );
  }

  Container RoundedRegisterInput(Size size, bool pass, String hintText,
      IconData iconData, TextEditingController control) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isLogin ? Colors.blue.withOpacity(0.3) : Colors.white),
      child: TextField(
        controller: control,
        obscureText: pass,
        cursorColor: Colors.blue.withOpacity(0.5),
        decoration: InputDecoration(
            icon: Icon(
              iconData,
              color: isLogin
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.blue.withOpacity(0.99),
            ),
            hintText: hintText,
            border: InputBorder.none),
      ),
    );
  }
}

Future<void> showDialog1(BuildContext context) async {
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
          child: SizedBox.expand(
              child: Container(
            child: Container(
              child: Column(
                children: [
                  Text(
                    "User not found",
                    style: TextStyle(fontSize: 30),
                  ),
                  Container(
                    child: Text(
                      "Please verify email and password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),
            ),
          )),
          margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
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
