

import 'package:estore/model/SliderImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {

  List<NetworkImage> images = [];
   late List<SliderImage> slider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(

        child: Container(
          child: Text("AUTHENTICATION FAILED!!",style: TextStyle(color: Colors.black),),
        )

      ),
      );
    // );
  }
}
