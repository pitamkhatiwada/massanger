import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


//Solucation of tihs type of problem Pitam khatiwada
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute:WelcomeScreen.id,
      routes: {
        WelcomeScreen.id :(context) => WelcomeScreen(),
        LoginScreen.id:(context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id:(context) => ChatScreen(),
      },
    );
  }
}
