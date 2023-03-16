import 'package:flutter/material.dart';
import 'package:massanger/screens/login_screen.dart';
import 'package:massanger/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:massanger/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(

                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                          fontSize: 45.0, fontWeight: FontWeight.w900,),
                      speed: const Duration(milliseconds: 500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),

            RoundedButton(
              title: 'Log In',color: Colors.lightBlueAccent,
              onPrased: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(color: Colors.blue, title: 'Register', onPrased:(){
              Navigator.pushNamed(context, RegistrationScreen.id);
            } ),
          ],
        ),
      ),
    );
  }
}




