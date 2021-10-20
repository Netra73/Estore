
import 'package:estore/api/getCategory.dart';
import 'package:estore/layouts/HomePage.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'displayproducts.dart';

class Categories extends StatelessWidget {
  //List<Category> category;
  Function _callBack;

  Categories(this._callBack);

  @override
  Widget build(BuildContext context) {
    return Container(

        child: FutureBuilder<List<Category>>(
          future: getCategory(),
          builder: (context,snapshot){
            if(snapshot.hasData){
             // category = snapshot.data;
              return Catlist(context,snapshot.data!);
            }

            return SpinKitThreeBounce(
              color: Colors.amber,
              size: 20,
            );
          },
        )
    );

  }
  Widget Catlist(BuildContext context,List<Category> category)
  {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            category.length,
                (index) => CategoryCard(

              text: category[index].title,
                  imgurl: category[index].icon,
              press: ()  {
                print("cid"+category[index].id);
                _callBack(category[index].id);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
     Key? key,
   // @required this.icon,
    required this.text,
    required this.press,
   required this.imgurl,
  }) : super(key: key);

  final String  text;
  final String  imgurl;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: SizedBox(
          //width: getProportionateScreenWidth(55),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                height: getProportionateScreenWidth(60),
                width: getProportionateScreenWidth(60),
                decoration: BoxDecoration(
                  //F3E2D5
                  //color: Color(0xfff3e2d5),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                 // shape:
                 // shape:
                ),
                child: Image.network(imgurl),
              ),
              SizedBox(height: 5),
              Text(text, textAlign: TextAlign.center,style: TextStyle(fontSize: 14.0),)
            ],
          ),
        ),
      ),
    );
  }
}
