
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
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/model/SliderImage.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
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
class launchproduct extends StatefulWidget {
  Function? _callBack;

  launchproduct([this._callBack]);

  @override
  _launchproductState createState() => _launchproductState();
}

class _launchproductState extends State<launchproduct> {

  List<NetworkImage> images = [];

  List<SliderImage>sList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Search_here() {
    return Container(
      color: mainStyle.mainColor,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: mainStyle.grayBorder,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Icon(
              Icons.category,
              color: Colors.orange,
              size: 25.0,
            ),
            Divider(),
            Icon(
              Icons.search,
              color: mainStyle.mainColor,
              size: 25.0,
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    //controller: TextEditingController(text: searchKey),
                    autofocus: false,
                    validator: (value) {
                      return null;
                    },
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Search()
                      ));
                    },
                    onFieldSubmitted: (value) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Search()
                      ));
                    },
                    decoration: InputDecoration(
                      hintText: "Search for over 1500+ Products",
                      contentPadding: EdgeInsets.all(5.0),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   print(sList.length);

    return SingleChildScrollView(
      child: Column(
        children: [
          Search_here(),
          if(widget._callBack!= null)
          Categories(widget._callBack!),
          Container(
            child: FutureBuilder<List>(
              future: getSliderImage(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List simage = snapshot.data!;
                  List<Widget> imageSliders = simage.map((e) =>
                      Container(
                        child: Image(
                          image: NetworkImage(e),
                        ),
                      )
                  ).toList();
                   return CarouselSlider(
                     options: CarouselOptions(
                       autoPlay: true,
                       aspectRatio: 2.0,
                       enlargeCenterPage: true,
                       
                     ),
                     items: imageSliders,
                   );
                }
                return SizedBox(height: 10.0,);
              },
            ),
          ),
       /* Container(
          height: 200.0,
          child: Carousel(
            images: [
              AssetImage("assets/images/banners.jpg"),
              AssetImage("assets/images/sliderone.jpg"),
              AssetImage("assets/images/slidertwo.jpg"),
            ],
            dotBgColor: Colors.transparent,
          ),
        ),*/

      /*  Container(
          padding: EdgeInsets.all(10.0),
          child: sList.length == 0 ? FutureBuilder(
            future: getSliderImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitThreeBounce(
                  color: Colors.amber,
                  size: 20,
                );
              }
              if (snapshot.hasData) {
                sList = snapshot.data;
                print(snapshot.data);
                return sliderImages();
              }
              return Container(
                child: Text('No slides'),
              );
            },
            },
          ) : sliderImages(),

        ),*/
          NewProducts(),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Container(
              height: 170.0,
              child: Column(
                children: [
                Image(
                    image: AssetImage("assets/images/launchtwo.jpg"),
                  )
                ],
              ),
            ),
          ),
          PopularProducts(),
          //RecentProducts(),
        ],
      ),
    );
  }

 Widget sliderImages()
  {
    return GridView.builder(
      itemCount: sList.length,
      itemBuilder: (cc, i) {
        var img = sList[i].image;
       print(img);
        return Container(
            height: 400,
           child: Carousel(
            images: [Image.network(img),],
             dotBgColor: Colors.transparent,
             ),
          );
        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );

  }

}
