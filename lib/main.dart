import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/screen1loginpage.dart';
import 'screens/screen2register.dart' as RegisterScreen;
import 'screens/screen3home.dart'; 
import 'screens/screen6donations.dart';
import 'screens/screen7profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => Screen1LoginPage(),
        '/register': (context) => RegisterScreen.Screen2Register(),
        '/home': (context) => Screen3Home(), 
        '/donations': (context) => Screen6Donations(),
        '/profile': (context) => Screen7Profile(),
      },
    );
  }
}