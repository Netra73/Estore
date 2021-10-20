import 'package:estore/api/getCategory.dart';
import 'package:estore/layouts/CategoryList.dart';
import 'package:estore/layouts/HomePage.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'Categories.dart';
import 'HomePage.dart';



class ExplorePage extends StatefulWidget {
  @override
  _ExplorePage createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  late List<Category> category;
  @override
  Widget build(BuildContext context){

   return
     Scaffold(
        // body: HomePage('1')
     );

  }
}

