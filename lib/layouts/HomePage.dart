import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:estore/api/getCategory.dart';
import 'package:estore/api/getProduct.dart';
import 'package:estore/config.dart';
import 'package:estore/layouts/ImageView.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:estore/model/VideoLink.dart';

//import 'Imagebanner.dart';
import 'ProductDetails.dart';

class HomePage extends StatefulWidget {

  final String getcid;
  const HomePage(this.getcid);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 late ScrollController _scrollController;
  bool _topbar = true;
   late List<Category> category;
  List<Product> product = [];

  late String text,imgurl;

//final String getcid ;

  //_HomePageState(this.getcid);
//  SharedPreferences myPrefs =  SharedPreferences.getInstance() as SharedPreferences;

    String cid = "1";

    //cid = getcid;
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
    setState(() {
      cid = widget.getcid;
    });
  }


  @override
  Widget build(BuildContext context) {
   // cid = widget.getcid;
    print(product.length);
    return Scaffold(

      //height: _topbar ? 360.0 : 0.0,
      /*appBar: AppBar(
        backgroundColor: mainStyle.mainColor,
        title: Text("Estore",style: mainStyle.text20White,),
      ),*/
      body:
      Column(
        children: [

          Container(
              // height: 60.0,
              //padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: FutureBuilder<List<Category>>(
                future: getCategory(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    category = snapshot.data!;
                    return newCatlist();
                  }

                  return SpinKitThreeBounce(
                    color: Colors.amber,
                    size: 20,
                  );
                },
              )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: product.length==0 ? FutureBuilder<List<Product>>(
                  future: getProduct(cid),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return SpinKitThreeBounce(
                        color: Colors.amber,
                        size: 20,
                      );
                    }
                    if(snapshot.hasData){
                      product = snapshot.data!;
                      return productList();
                    }
                    return Container(
                      child: Text('No Products'),
                    );
                  },
                ) : productList(),
              ),

            ),
          ),
        ],
      ),
    );
  }

  ListView catList() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
       // itemCount: category.length,
        itemCount: 2,
        itemBuilder: (context,i){
          return GestureDetector(
            onTap: (){
              setState(() {
                product.clear();
                cid = category[i].id;
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              width: 100 ,
              height: 100,
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: Colors.white,width: 1.2),
                  color: cid==category[i].id ? mainStyle.secColor : mainStyle.chipColor,

              ),
              child: Text(category[i].title,style: cid==category[i].id ? mainStyle.text16White :  mainStyle.text16,),
            ),
          );
        });
  }
  Widget newCatlist()
  {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(

            category.length,
                (i) =>
                   GestureDetector(onTap: (){
                     setState(() {
                       product.clear();
                       cid = category[i].id;
                     });

                   },
                     child: Padding(
                       padding: EdgeInsets.all(6.0),
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
                               child: Image.network(category[i].icon),
                             ),
                             SizedBox(height: 5),
                             Text(category[i].title,style: cid==category[i].id ? mainStyle.text14Selected :  mainStyle.text14,),
                           ],
                         ),
                       ),
                     ),
                   )
          ),
        ),
      ),
    );
  }

  ListView productList() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
      itemCount: product.length,

        itemBuilder: (context, i) {

          int offer = 0;
          String mrp = product[i].rate;
          if(product[i].offer!='0'){
            offer = int.parse(product[i].offer);

            double offRate = (offer/100)*int.parse(mrp);
            double price = int.parse(mrp) - offRate;
            mrp = price.toStringAsFixed(0);
          }

          var thumb = jsonDecode(product[i].thumb);
          String thumbImg = thumb[0];

          return  GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductDetails(product[i])
              ));
            },
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>ImageView(product[i].thumb)
                                  ));
                                },
                                child: Hero(
                                  tag : product[i].thumb,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Image(
                                      image: NetworkImage(thumbImg),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5,),
                                      Text(product[i].title, style: mainStyle.text16,),
                                      Text(product[i].size, style: mainStyle.text12,),
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('\u20B9'+mrp+' ', style: mainStyle.text18Rate,),
                                                if(offer>0)
                                                  Text(' \u20B9'+product[i].rate, style: TextStyle(color: mainStyle.textColor,fontSize: 14,decoration: TextDecoration.lineThrough),),
                                              ],
                                            ),
                                            RaisedButton(
                                              onPressed: (){
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => ProductDetails(product[i])
                                                ));
                                              },
                                              color: Colors.amber,
                                              child: Text('BUY', style: TextStyle(fontSize: 16,color: Colors.white),),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}