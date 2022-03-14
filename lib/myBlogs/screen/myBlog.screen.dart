import 'package:flutter/material.dart';
import 'package:flutterx/MyBlogS/controller/MyBlogS.controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletons/skeletons.dart';

import '../../network/network.dart';

class MyBlogScreen extends StatefulWidget {
  const MyBlogScreen({Key? key}) : super(key: key);
  @override
  State<MyBlogScreen> createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  final MyBlogFeedScreenController myBlogScreenController =
      Get.put(MyBlogFeedScreenController());

  @override
  void initState() {
    super.initState();
    myBlogScreenController.fetchBlog();
  }

  String base = 'https://s3-us-east-2.amazonaws.com/flutter-blog-info/';
  static current_data(DateTime val) {
    var str = "2019-04-05T14:00:51.000Z";
    var newStr = str.substring(0, 10) + ' ' + str.substring(11, 23);
    DateTime dt = DateTime.parse(newStr);
    return DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt);
  }

  void showAlert(response, state) {
    Get.snackbar(
      "My Blogs",
      response,
      icon: state
          ? const Icon(Icons.check_circle, color: Colors.black)
          : const Icon(Icons.block_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: state ? Colors.blue[400] : Colors.red[200],
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      isDismissible: true,
    );
  }

  void deletePost(int id) async {
    Map data = {'id': id};

    var response = await dio.post("/delete-post", data: data);
    if (response.statusCode == 200) {
      myBlogScreenController.fetchBlog();
      showAlert("Deleted Successfully", true);
    } else {
      showAlert("Something Went wrong", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Obx(() => ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: myBlogScreenController.blogList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var blog = myBlogScreenController.blogList[index];
                        return (myBlogScreenController.isLoading.value)
                            ? SkeletonListView()
                            : Card(
                                shadowColor: Colors.black,
                                // color: Colors.[100],
                                elevation: 2,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  side:
                                      BorderSide(width: 0, color: Colors.white),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: Text(
                                            blog.postedBy.substring(0, 2),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      title: Text(
                                          '${blog.postedBy.substring(0, 1).toUpperCase()}${blog.postedBy.substring(1, blog.postedBy.length)}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      subtitle: Text(
                                          // DateFormat("EEE, d MMM yyyy HH:mm:ss").format(blog.postedTime),
                                          // DateFormat.yMMMd().format(blog.postedTime),
                                          DateFormat.yMMMd()
                                              .format(blog.postedTime),
                                          // current_data(),,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(blog.blogTitle,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(blog.blogSubtitle,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          SizedBox(height: height * 0.01),
                                          Text(blog.story,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              softWrap: false,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      deletePost(blog.id);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.black))
                                              ])
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               horizontal: 0,
                                          //               vertical: 5),
                                          //       child: IconButton(
                                          //         icon: const Icon(
                                          //             Icons.thumb_up),
                                          //         tooltip:
                                          //             'Increase volume by 10',
                                          //         onPressed: () {},
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
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
