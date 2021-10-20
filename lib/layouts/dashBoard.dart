import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:estore/api/getCategory.dart';
import 'package:estore/api/getProduct.dart';
import 'package:estore/api/getSlider.dart';
import 'package:estore/layouts/Categories.dart';
import 'package:estore/layouts/ExplorePage.dart';
import 'package:estore/layouts/ImageView.dart';
import 'package:estore/layouts/LoyalityPage.dart';
import 'package:estore/layouts/PopularProducts.dart';
import 'package:estore/layouts/NewProducts.dart';
import 'package:estore/layouts/OffersPage.dart';
import 'package:estore/layouts/SpecialOffers.dart';
import 'package:estore/layouts/VideosPage.dart';
import 'package:estore/layouts/displayproducts.dart';
import 'package:estore/layouts/launchproduct.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/model/SliderImage.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

//import 'Imagebanner.dart';
import 'PopProducts.dart';
import 'ProductDetails.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'RecentProducts.dart';
import 'Search.dart';
import 'products.dart';
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
              backgroundColor:Colors.pinkAccent
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              title: Text('Offers'),
              backgroundColor: Colors.pinkAccent
          ),
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
        elevation: 5
    ),
    );
  }
}
