import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutterx/Feed/model/feed.model.dart';
import 'package:flutterx/network/network.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeedController extends GetxController {
  var blogList = [].obs;
  var isLoading = false.obs;

  void fetchBlog() async {
    isLoading(true);
    var blogs = await fetch();
    isLoading(false);

    if (blogs != null) {
      blogList.value = blogs;
    }
  }

  likeBlog(var value) async {
    var updateLike = await upDateLike(value);
    fetchBlog();
    //  blogList.refresh();
  }

  reverseBlog() async {
    isLoading(true);
    var blogs = await fetch();
    isLoading(false);

    if (blogs != null) {
      blogList.value = List.from(blogs.reversed);
    }
  }
}

Future fetch() async {
  final response =
      await http.get(Uri.parse("http://localhost:4000/get-all-blog"));
  if (response.statusCode == 200) {
    var json = response.body;
    // print(json);
    final List<BlogFeed> blog = blogFeedFromJson(response.body);
    return blog;
  } else {
    return null;
  }
}

Future upDateLike(var value) async {
  var response = await http.post(
    Uri.parse('http://localhost:4000/update-like'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': value['id'].toString(),
      'like': value['like'].toString(),
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
