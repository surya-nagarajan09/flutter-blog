import 'package:flutter/material.dart';
import 'package:flutterx/homePage/screens/home_screen.dart';
import 'package:flutterx/login/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dioService;

import '../../network/network.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

  void handleJoin() async {
    Map joinData = {
      "email": email.text,
      "password": password.text,
      "name": name.text,
      "image":imageId
    };
    setState(() {
      isLoading = true;
    });
    var response = await dio.post('/join', data: joinData);

    setState(() {
      isLoading = false;
    });
    if (response.data["response"]) {
      navigate();
    } else {
      showAlert(response.data['results'], response.data["response"]);
    }
  }

  void navigate() {
    Get.to(const LoginScreen());
  }

  void showAlert(response, state) {
    Get.snackbar(
      "Login",
      response,
      icon: state
          ? const Icon(Icons.check_circle, color: Colors.black)
          : const Icon(Icons.block_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: state ? Colors.blue[400] : Colors.red[200],
      borderRadius: 20,
      margin:const  EdgeInsets.all(15),
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

  bool uploaded = false;
  late File imageFile;
  late String imageId = "no-image";

  profileUpdate() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image?.path != null) {
      setState(() {
        imageFile = File(image!.path);
        // blogController.imageName = File(image.name);
        uploaded = true;
      });
    }
    var uploadedImgagetoS3=await uploadImage();
    // print(uploadedImgagetoS3);
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    String fileName = imageFile.path.split('/').last;
    dio.options.connectTimeout = 100000;
    dio.options.receiveTimeout = 100000;
    dio.options.sendTimeout = 100000;
    dioService.FormData formData = dioService.FormData.fromMap({
      "image": await dioService.MultipartFile.fromFile(imageFile.path,
          filename: fileName),
    });
    var response = await dio.post("/upload-image", data: formData);
    debugPrint('uploadImage$response');
    var key = response.data['key'];
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        imageId = key;
      });
      return true;
    } else {
      return false;
    }
  }

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Text("Create Account",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 32,
                                fontWeight: FontWeight.bold))
                      ]),
                      // ignore: prefer_const_constructors
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          uploaded
                              ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 80,
                                  child: ClipRRect(
                                      // borderRadius:BorderRadius.circular(150),
                                      child: Image.file(imageFile,
                                          fit: BoxFit.contain, height: 300)))
                              : GestureDetector(
                                  child: Stack(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 65,
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf9tgqR8Q5mHsKEzqYiU49rNvST7mJkgfVhiekf8SZdf9TDt8tztGo2RWXyJw_NjqGGWg&usqp=CAU',
                                          ),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.bottomCenter,
                                          child: const Icon(Icons.add_a_photo))
                                    ],
                                  ),
                                  onTap: () {
                                    profileUpdate();
                                  },
                                )
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      const Text("Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: name,
                        cursorColor: Colors.black,
                        style: inputTextStyle,
                        decoration: inputDecoration,
                      ),
                      SizedBox(height: height * 0.03),
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
                          print(text);
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

                      SizedBox(height: height * 0.01),
                      Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                handleJoin();
                              },
                              child: const Text("Create Account",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)))),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Already have an account ?"),
                          TextButton(
                              onPressed: () {
                                Get.to(const LoginScreen());
                              },
                              child: const Text("Log in",
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
