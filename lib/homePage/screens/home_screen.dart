// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutterx/joinpage/screens/join_screen.dart';
import 'package:get/get.dart';

import '../../login/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> images = [
    'https://cdn.dribbble.com/users/1338391/screenshots/15415760/media/11a5ffbbe85f4579d214c595124edebe.jpg?compress=1&resize=1200x900&vertical=top',
    'https://cdn.dribbble.com/users/1338391/screenshots/15412369/media/db9cc51e777dd9f42e89034027d0786b.jpg?compress=1&resize=1200x900&vertical=top',
    'https://cdn.dribbble.com/users/1338391/screenshots/15420431/media/df77d0c80121166cc07a710378f43625.jpg?compress=1&resize=1200x900&vertical=top',
    'https://cdn.dribbble.com/users/1338391/screenshots/15461540/media/040828259b15aa838bfc68b664051db0.jpg',
    'https://cdn.dribbble.com/users/1338391/screenshots/15457107/media/b17248e7459b760da025bd8f7efbfe51.jpg?compress=1&resize=1200x900&vertical=top'
  ];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration:const  BoxDecoration(
          image:const  DecorationImage(
            image:const  NetworkImage(
                'https://cdn.dribbble.com/users/464226/screenshots/16512478/media/f64da7c4d911ac610555ec7aa3fb8787.png'),
            fit:  BoxFit.cover,
          ),
          // color: Colors.blue[50]
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.3),
            Center(
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    itemBuilder: (context, index, realIdx) {
                      return Center(
                          child: Image.network(images[index],
                              fit: BoxFit.cover, width: 1000));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(JoinScreen());
                  },
                  child:const 
                      Text("Get Started", style: const TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF000000)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(LoginScreen());
                  },
                  child:const Text("Log in",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF000000)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20)),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 30))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
