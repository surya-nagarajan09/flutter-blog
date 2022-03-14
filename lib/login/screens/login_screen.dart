import 'package:flutter/material.dart';
import 'package:flutterx/home/screens/home.screens.dart';
import 'package:flutterx/homePage/screens/home_screen.dart';
import 'package:flutterx/joinpage/screens/join_screen.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../network/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();

  void handleLogin() async {
    Map loginData = {
      "email": email.text,
      "password": password.text,
    };
    setState(() {
      isLoading = true;
    });
    var response = await dio.post('/login', data: loginData);

    if (response.data['response']) {
      setState(() {
        isLoading = false;
      });
      // print(response.data['image']);
      // print(response.data);
      await flutterStorage.write(key: "user", value: email.text);
      await flutterStorage.write(
          key: "user_name", value: response.data['user_name']);
      await flutterStorage.write(key: "avatar", value: response.data['image']);
      await flutterStorage.write(
          key: "user_id", value: response.data['user_id'].toString());
      navigate();
    } else {
      showAlert(response.data['result'], response.data['response']);
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigate() {
    Get.to(const Home());
  }

  void showAlert(response, state) {
    Get.snackbar(
      "Login",
      response,
      icon: state
          ? const Icon(Icons.check_circle, color: Colors.black)
          : const Icon(Icons.block_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      isDismissible: true,
    );
  }

  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[300],
    border: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
  );
  final inputTextStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.black,
                  size: 100,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ignore: prefer_const_constructors
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 1),
                        child: const Text("Log In",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10.0),
                        // ignore: unnecessary_const
                        child: const Text("Account",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: height * 0.04),
                      const Text("Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: email,
                        cursorColor: Colors.black,
                        style: inputTextStyle,
                        decoration: inputDecoration,
                        maxLength: 30,
                        onChanged: (text) {
                          // print(text);
                        },
                      ),
                      SizedBox(height: height * 0.03),
                      const Text("Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: password,
                        obscureText: true,
                        cursorColor: Colors.black,
                        style: inputTextStyle,
                        decoration: inputDecoration,
                        maxLength: 15,
                      ),
                      SizedBox(height: height * 0.03),

                      SizedBox(height: height * 0.01),

                      Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                if (email.text.length != 0 &&
                                    password.text.length != 0) {
                                  handleLogin();
                                }
                                null;
                              },
                              child: const Text("Login in Account",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)))),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Dont have an account ?"),
                          TextButton(
                              onPressed: () {
                                Get.to(const JoinScreen());
                              },
                              child: const Text("Join now",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              style:
                                  TextButton.styleFrom(primary: Colors.black))
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
