import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../network/network.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:dio/dio.dart' as dioService;

class BlogController extends GetxController {
  var isLoading = false.obs;
  late String imageId = "no-image";
  String img =
      'https://quadmenu.com/divi/wp-content/uploads/sites/8/2013/06/placeholder-image.png';

  TextEditingController title = TextEditingController();
  TextEditingController subTitle = TextEditingController();
  TextEditingController description = TextEditingController();

  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();

  late File imageFile;

  Future submitBlog() async {
    var posted_by = await flutterStorage.read(key: "user_name");
    var user_id = await flutterStorage.read(key: "user_id");

    Map blog_details = {
      'title': title.text,
      'subtitle': subTitle.text,
      'description': description.text,
      'posted_by': posted_by,
      'user_id': user_id,
      'image': imageId
      // =="" ? 'https://quadmenu.com/divi/wp-content/uploads/sites/8/2013/06/placeholder-image.png' : imageId
    };
    var response = await dio.post('/create-blog', data: blog_details);
    if (response.statusCode == 200) {
      imageId = "no-image";
      title.text = "";
      subTitle.text = "";
      description.text = "";
      imageFile = File("");
      return true;
    } else {
      return false;
    }
  }

  Future uploadImage() async {
    isLoading(true);
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
      isLoading(false);
      imageId = key;
      return true;
    } else {
      return false;
    }
  }
}
