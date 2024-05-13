import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_navi_stick/screens/signin_screen.dart';
import 'package:smart_navi_stick/reusable_widgets/user_name_provider.dart';
import 'package:smart_navi_stick/screens/home_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'Smart Navi Stick',
      // options: const FirebaseOptions(
      //   apiKey: 'AIzaSyD7_YIfFeBgul-WuaNMCDkISwUZvulmGdo',
      //   appId: 'id',
      //   messagingSenderId: '',
      //   projectId: 'smart-navi-stick',
      // ),
      );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserNameProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const SignInScreen(),
    );
  }
}
