import 'package:estore/layouts/products.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';

import 'categories.dart';

class DisplayProducts extends StatelessWidget {
  final String cat_index;
  final String cat_name;

  const DisplayProducts({ Key? key,required this.cat_index,  required this.cat_name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainStyle.mainColor,

              title: Text(cat_name,style: mainStyle.text20White)
        ),
        body: Container(
          child :Products(cat_index),
        ),
    );
  }
}
