import 'package:estore/layouts/ExplorePage.dart';
import 'package:estore/layouts/LoyalityPage.dart';
import 'package:estore/layouts/OffersPage.dart';
import 'package:estore/layouts/VideosPage.dart';
import 'package:estore/layouts/launchproduct.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class dashBoard extends StatefulWidget {
  @override
  _dashBoardState createState() => _dashBoardState();
}

class _dashBoardState extends State<dashBoard> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    //launchproduct(),
    launchproduct(),
    OffersPage(),
    ExplorePage(),
    LoyalityPage(),
    VideosPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //height: _topbar ? 360.0 : 0.0,
      backgroundColor: mainStyle.bgColor,
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                backgroundColor: Colors.pinkAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_outlined),
                title: Text('Offers'),
                backgroundColor: Colors.pinkAccent),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              title: Text('Explore'),
              backgroundColor: Colors.pinkAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.loyalty_rounded),
              title: Text('Loyality'),
              backgroundColor: Colors.pinkAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call_sharp),
              title: Text('Videos'),
              backgroundColor: Colors.pinkAccent,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 35,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
