import 'package:flutter/material.dart';
import 'package:social_sphere/auth/auth.dart';
import 'package:social_sphere/auth/login_or_register.dart';
import 'package:social_sphere/firebase_options.dart';
import 'package:social_sphere/pages/home_page.dart';
import 'package:social_sphere/pages/login_page.dart';
import 'package:social_sphere/pages/profile_page.dart';
import 'package:social_sphere/pages/resgister_page.dart';
import 'package:social_sphere/pages/users_page.dart';
import 'package:social_sphere/theme/dark_mode.dart';
import 'package:social_sphere/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page':(context) => HomePage(),
        '/profile_page':(context) => ProfilePage(),
        '/users_page':(context) => const UsersPage(),
      },
    );
  }
}