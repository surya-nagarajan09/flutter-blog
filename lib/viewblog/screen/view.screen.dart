import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBlog extends StatefulWidget {
  const ViewBlog({Key? key}) : super(key: key);

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  dynamic argumentData = Get.arguments;
  String base = 'https://s3-us-east-2.amazonaws.com/flutter-blog-info/';

  @override
  void initState() {
    super.initState();
    print(argumentData[0]);
    print(argumentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //                  Container(
                    //   height: double.infinity,
                    //   alignment: Alignment.center, // This is needed
                    //   child: Image.asset(
                    //     Constants.ASSETS_IMAGES + "logo.png",
                    //     fit: BoxFit.contain,
                    //     width: 300,
                    //   ),
                    // );
                    Image.network(
                        argumentData[3] == "no_image"
                            ? 'https://quadmenu.com/divi/wp-content/uploads/sites/8/2013/06/placeholder-image.png'
                            : base + argumentData[3],
                        height: 250,
                        fit: BoxFit.contain),
                    const SizedBox(height: 20),
                    Text(
                      argumentData[0],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.justify, // has impact
                    ),
                    const SizedBox(height: 5),
                    Text(
                      argumentData[1],
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.justify, // has impact
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        argumentData[2],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.justify, // has impact
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
