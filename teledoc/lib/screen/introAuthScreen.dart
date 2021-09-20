import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:teledoc/Authentication/loginAndSignUp.dart';
import 'package:teledoc/screen/searchPage.dart';

class IntroAuthScreen extends StatefulWidget {
  const IntroAuthScreen({Key? key}) : super(key: key);

  @override
  _IntroAuthScreenState createState() => _IntroAuthScreenState();
}

class _IntroAuthScreenState extends State<IntroAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
            title: "Welecome To TeleDoc",
            body: "We keep your in contact with your Health Specialist",
            image: Container(
              child: Center(
                child: Image.asset(
                  "assets/images/gif3.gif",
                  fit: BoxFit.cover,
                ),
              ),
            )),
        PageViewModel(
            title: " Appointment Scheduling",
            body:
                "Allow individual book appointment with their health specialist,from their home",
            image: Center(
              child: Image.asset(
                "assets/images/gif1.gif",
              ),
            )),
        PageViewModel(
            title: "Tele-Consultation",
            body:
                "Be able to  have online consultation from home with your health specialist ",
            image: Center(
              child: Image.asset(
                "assets/images/gif2.gif",
              ),
            )),
        // PageViewModel(
        //     title: "Have Video Conference",
        //     body: "Perform video  conference only by health professional",
        //     image: Center(
        //       child: Image.asset(
        //         "assets/images/on1.png",
        //       ),
        //     )),

        PageViewModel(
            title: "Skip Long waiting list ",
            body: "",
            image: Container(
              margin: EdgeInsets.only(top: 30),
              child: Center(
                child: Image.asset(
                  "assets/images/gif6.gif",
                  fit: BoxFit.cover,
                ),
              ),
            )),
      ],
      onDone: () {
       Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginAndSignUpPage()));
      },
      onSkip: () {},
      showSkipButton: true,
      skip: const Icon(
        Icons.skip_next,
        size: 45,
      ),
      next: const Icon(Icons.arrow_forward_ios),
      done: Text(
        "Done",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
