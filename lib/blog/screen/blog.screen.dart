import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/blog.controller.dart';
import 'package:image_picker/image_picker.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogController blogController = Get.put(BlogController());
  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[300],
    border: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
  );
  final inputTextStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 18.0,
  );

  static const headerStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18);

  bool isLoading = false;

  void showAlert(response, state) {
    Get.snackbar(
      response,
      "Story Created!!!",
      icon: state
          ? const Icon(Icons.check_circle, color: Colors.white)
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

  bool uploaded = false;

  final ImagePicker picker = ImagePicker();
  imageSelectorGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image?.path != null) {
      setState(() {
        blogController.imageFile = File(image!.path);
        // blogController.imageName = File(image.name);
        uploaded = true;
      });
    }
    if (uploaded) {
      setState(() {
        isLoading = true;
      });

      var result = await blogController.uploadImage();
      if (result) {
        showAlert("Uploaded banner", true);
        setState(() {
          isLoading = false;
        });
      } else {
        showAlert("Something Went Wrong", false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.blue,
                  size: 100,
                ),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var result = await blogController.submitBlog();
                                if (result) {
                                  showAlert("Story Created", true);
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  showAlert("Something Went Wrong", true);
                                }
                              },
                              child: const Text("Publish"),
                              style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const Text("Cover Image", style: headerStyle),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            uploaded
                                ? Container(
                                    width: 200,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        // color:Colors.blue,
                                        image: DecorationImage(
                                            image: FileImage(
                                                blogController.imageFile))))
                                : Container(
                                    width: 200,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://cdn.dribbble.com/users/453325/screenshots/5573953/empty_state.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            IconButton(
                              icon: const Icon(Icons.file_upload_outlined),
                              tooltip: 'Upload Cover',
                              onPressed: () async {
                                imageSelectorGallery();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        const Text("Title", style: headerStyle),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: blogController.title,
                          cursorColor: Colors.black,
                          style: inputTextStyle,
                          decoration: inputDecoration,
                          maxLength: 30,
                        ),
                        SizedBox(height: height * 0.02),
                        const Text("Sub Title", style: headerStyle),
                        SizedBox(height: height * 0.01),
                        TextField(
                          controller: blogController.subTitle,
                          cursorColor: Colors.black,
                          style: inputTextStyle,
                          decoration: inputDecoration,
                          maxLength: 30,
                        ),
                        SizedBox(height: height * 0.02),
                        const Text("Tell your Story", style: headerStyle),
                        SizedBox(height: height * 0.02),
                        TextField(
                          controller: blogController.description,
                          cursorColor: Colors.black,
                          style: inputTextStyle,
                          decoration: inputDecoration,
                          keyboardType: TextInputType.multiline,
                          minLines: 6,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
