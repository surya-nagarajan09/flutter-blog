import 'package:flutter/material.dart';
import 'package:flutterx/home/screens/home.screens.dart';
import 'package:flutterx/homePage/screens/home_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();
  String? user;
  bool isLoading = false;
  String? avatar;
  String? username;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    var checkUser = await flutterStorage.read(key: "user");
    int index = checkUser.toString().indexOf("@");
    setState(() {
      user = checkUser.toString();
      avatar = checkUser.toString().substring(0, 2).toUpperCase();
      username = checkUser.toString().substring(0, index);
    });
  }

  Future deleteUser() async {
    setState(() {
      isLoading = true;
    });
    await flutterStorage.delete(key: "user");
    setState(() {
      isLoading = false;
    });
    Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.blue,
                  size: 100,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.3,
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xff0a58ed),
                              child: Text(avatar ?? "",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 50)),
                              minRadius: 60,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(username ?? "",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            SizedBox(height: height * 0.02),
                            Text(user ?? "",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            const ListTile(
                              title: Text('Settings',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              leading: Icon(Icons.settings,
                                  size: 25, color: Color(0xff0a58ed)),
                              trailing: Icon(Icons.arrow_right_sharp,
                                  size: 25, color: Color(0xff0a58ed)),
                            ),
                            const ListTile(
                              title: Text('Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              leading: Icon(Icons.info_outline,
                                  size: 25, color: Color(0xff0a58ed)),
                              trailing: Icon(Icons.arrow_right_sharp,
                                  size: 25, color: Color(0xff0a58ed)),
                            ),
                            ListTile(
                              title: const Text('Log out',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              leading: const Icon(Icons.logout_outlined,
                                  size: 25, color: const Color(0xff0a58ed)),
                              trailing: const Icon(Icons.arrow_right_sharp,
                                  size: 25, color: const Color(0xff0a58ed)),
                              onTap: () {
                                deleteUser();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
