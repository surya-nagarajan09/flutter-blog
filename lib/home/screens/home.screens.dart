import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterx/Feed/screen/feed.screen.dart';
import 'package:flutterx/account/screen/account.screen.dart';
import 'package:flutterx/blog/screen/blog.screen.dart';
import 'package:flutterx/homePage/screens/home_screen.dart';
import 'package:flutterx/myBlogs/screen/myBlog.screen.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../network/network.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: Home._title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  int _selectedIndex = 0;
  String base = 'https://s3-us-east-2.amazonaws.com/flutter-blog-info/';
  late String avatarImage;
  late String name;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Feed(),
    MyBlogScreen(),
    BlogScreen(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future deleteUser() async {
    await flutterStorage.delete(key: "user");
    Get.to(HomeScreen());
  }

  Future getUser() async {
    var user = await flutterStorage.read(key: "user_id");
    Map data = {"id": user};
    var response = await dio.post('/get-avatar', data: data);

    setState(() {
      avatarImage = response.data["image"];
      name = response.data["name"].toString();
    });
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(150, 90, 10, 100),
      items: [
        PopupMenuItem<String>(
            child: GestureDetector(
              child: const Text('Log out',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              onTap: () {
                deleteUser();
              },
            ),
            value: 'Log out'),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          'https://flutterindia.dev/flappy-dash.gif'),
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                        child: avatarImage == "no-image"
                            ? CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Text(name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(base + avatarImage)),
                        onTap: () {
                          _showPopupMenu();
                        }),
                  ]),
            ),
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_rounded, size: 25),
            label: 'Feed',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_rounded, size: 25),
            label: 'My Blogs',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create_outlined, size: 25),
            label: 'Create',
            backgroundColor: Colors.white,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.verified_user, size: 25),
          //   label: 'account',
          //   backgroundColor: Colors.white,
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
