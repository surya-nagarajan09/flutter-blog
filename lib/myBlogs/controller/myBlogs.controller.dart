import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterx/Feed/model/feed.model.dart';
import 'package:flutterx/myBlogs/model/myBlog.model.dart';
import 'package:flutterx/network/network.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyBlogFeedScreenController extends GetxController {
  var blogList = [].obs;
  var isLoading = false.obs;

  void sample(){
    print("hai");
  }

  void fetchBlog() async {
    isLoading(true);
    var blogs = await fetch();
    isLoading(false);

    if (blogs != null) {
      blogList.value = blogs;
    }
  }


}

Future fetch() async {
  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();
  var user_id = await flutterStorage.read(key: "user_id");

  var response = await http.post(
    Uri.parse('http://localhost:4000/get-blog'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': user_id.toString(),
    }),
  );

  if (response.statusCode == 200) {
    var json = response.body;

    final List<MyblogFeed> blog = myblogFeedFromJson(response.body);
    return blog;
  } else {
    return null;
  }
}
