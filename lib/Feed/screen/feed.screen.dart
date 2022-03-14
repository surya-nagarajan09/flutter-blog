import 'dart:math';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutterx/Feed/controller/feed.controller.dart';
import 'package:flutterx/blog/screen/blog.screen.dart';
import 'package:flutterx/viewblog/screen/view.screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math' as math;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FeedController feedController = Get.put(FeedController());
  final ScrollController _controller = ScrollController();
  String base = 'https://s3-us-east-2.amazonaws.com/flutter-blog-info/';

  @override
  void initState() {
    super.initState();
    feedController.fetchBlog();
  }

  static current_data(DateTime val) {
    var str = "2019-04-05T14:00:51.000Z";
    var newStr = str.substring(0, 10) + ' ' + str.substring(11, 23);
    DateTime dt = DateTime.parse(newStr);
    return DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt);
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.black,
            onPressed: _scrollDown,
            child: const Icon(Icons.arrow_upward, color: Colors.white)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              feedController.fetchBlog();
                            },
                            style: OutlinedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                            child: const Text("Featured")),
                        SizedBox(width: width * 0.1),
                        ElevatedButton(
                            onPressed: () {
                              feedController.reverseBlog();
                            },
                            style: OutlinedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                            child: const Text("Recent")),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Obx(() => ListView.separated(
                          controller: _controller,
                          padding: const EdgeInsets.all(8),
                          itemCount: feedController.blogList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var blog = feedController.blogList[index];
                            return (feedController.isLoading.value)
                                ? SkeletonListView()
                                : Card(
                                    elevation: 2,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      side: BorderSide(
                                          width: 0, color: Colors.white),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Text(
                                                blog.postedBy.substring(0, 2),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          title: Text(
                                              '${blog.postedBy.substring(0, 1).toUpperCase()}${blog.postedBy.substring(1, blog.postedBy.length)}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          subtitle: Text(
                                              // DateFormat("EEE, d MMM yyyy HH:mm:ss").format(blog.postedTime),
                                              // DateFormat.yMMMd().format(blog.postedTime),
                                              DateFormat.yMMMd()
                                                  .format(blog.postedTime),
                                              // current_data(),,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(blog.blogTitle,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(blog.blogSubtitle,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey)),
                                              SizedBox(height: height * 0.02),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewBlog(),
                                                      arguments: [
                                                        blog.blogTitle,
                                                        blog.blogSubtitle,
                                                        blog.story,
                                                        blog.image
                                                      ]);
                                                },
                                                child: Text(blog.story,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              SizedBox(height: height * 0.01),
                                              Image.network(
                                                  blog.image == 'no-image'
                                                      ? 'https://quadmenu.com/divi/wp-content/uploads/sites/8/2013/06/placeholder-image.png'
                                                      : base + blog.image,
                                                  height: 250,
                                                  width: 500,
                                                  fit: BoxFit.fill),
                                              SizedBox(height: height * 0.01),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0,
                                                        vertical: 5),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.thumb_up),
                                                      tooltip: 'Like',
                                                      onPressed: () {
                                                        var blog =
                                                            feedController
                                                                    .blogList[
                                                                index];
                                                        Map liked = {
                                                          "id": blog.id,
                                                          'like': blog.likes + 1
                                                        };

                                                        feedController
                                                            .likeBlog(liked);
                                                      },
                                                    ),
                                                  ),
                                                  Text(blog.likes.toString())
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ))),
              ],
            ),
          ),
        ));
  }
}
