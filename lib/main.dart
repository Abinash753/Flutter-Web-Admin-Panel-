import 'dart:io';

import 'package:ev_admin/helper/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/helper.dart';
import 'helper/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: "AIzaSyBQWoFhlgj8fb_ctZcR_Uh1eEDerbPqavc",
            appId: "1:587521057124:web:46611161fa001d78ac5a71",
            messagingSenderId: "587521057124",
            projectId: "ev-connect-app--2",
            storageBucket: "ev-connect-app--2.appspot.com",
          )
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  //retrieve current user
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "A_D_M_I_N",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          titleTextStyle: Helper.pageTitle,
        ),
      ),
      home: user != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}
