//import 'package:ChefPad_v2_0/screens/create_post_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wild_boar/screens/FeedScreen.dart';
import 'package:wild_boar/screens/ProfileScreen.dart';
import 'package:wild_boar/screens/SendReportScreen.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'CookPad',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          )
        )
      ), */

      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SendReportScreen(),
          ProFileScreen(),
        ],
        onPageChanged: (
          int index,
        ) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            size: 32.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.drive_folder_upload,
            size: 32.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.account_circle,
            size: 32.0,
          )),
        ],
      ),
    );
  }
}
