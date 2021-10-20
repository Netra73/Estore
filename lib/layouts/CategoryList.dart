import 'dart:convert';

import 'package:estore/api/getCategory.dart';
import 'package:estore/api/getProduct.dart';
import 'package:estore/layouts/ImageView.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ProductDetails.dart';


class CategoryList extends StatefulWidget {



  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

   late List<Category> category;
  String cid = '1';
 late ScrollController _scrollController;
  bool _topbar = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.userScrollDirection==ScrollDirection.forward){
        if(!_topbar) {
          setState(() {
            _topbar = true;
          });
        }
      }
      if(_scrollController.position.userScrollDirection==ScrollDirection.reverse){
        if(_topbar) {
          setState(() {
            _topbar = false;
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainStyle.bgColor,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
                child: FutureBuilder<List<Category>>(
                  future: getCategory(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return SpinKitThreeBounce(
                        color: Colors.amber,
                        size: 20,
                      );
                    }
                    if(snapshot.hasData){
                      category = snapshot.data!;
                      return catcardList();
                    }
                    return Container(
                      child: Text('No Products'),
                    );
                  },
                ),
              ),
          ),
        ],
      ),

    );


  }
  ListView catcardList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: category.length,

        itemBuilder: (context,i){
      return Card(

        elevation: 4,
        color: Colors.white,
        child: ListTile(

          title: Text(category[i].title),
        ),
      );

        },
    );
      }


  ListView catList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: category.length,
        itemBuilder: (context,i){
          return GestureDetector(
            onTap: (){
              setState(() {

                cid = category[i].id;
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              decoration: BoxDecoration(
                  border: mainStyle.grayBorder,
                  color: cid==category[i].id ? mainStyle.secColor : mainStyle.chipColor,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Text(category[i].title,style: cid==category[i].id ? mainStyle.text16White :  mainStyle.text16,),
            ),
          );
        });
  }

}
