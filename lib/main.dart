import 'package:flutter/material.dart';
import 'package:flutterx/homePage/screens/home_screen.dart';
import 'package:flutterx/joinpage/screens/join_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'home/screens/home.screens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userExist = false;
  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();

  @override
  void initState() {
    getUser();
  }

  Future getUser() async {
    var checkUser = await flutterStorage.read(key: "user");
    if (checkUser != null) {
      setState(() {
        userExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: userExist ? Home() : HomeScreen(),
    );
  }
}
