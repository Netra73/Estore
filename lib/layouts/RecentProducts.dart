import 'package:estore/api/getRecentProducts.dart';
import 'package:estore/layouts/PopProducts.dart';
import 'package:estore/layouts/products.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:flutter/material.dart';
import 'package:estore/api/getProduct.dart';
import 'package:estore/layouts/ProductDetails.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:estore/style/textstyle.dart';
import '../config.dart';
import 'PopProductcard.dart';
import 'PopularProductCard.dart';
import 'RecentProductCards.dart';
import 'section_title.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import '../model/Product.dart';
import '../config.dart';



class  RecentProducts extends StatefulWidget {
  @override
  _RecentProducts createState() => _RecentProducts();
}

class _RecentProducts extends State<RecentProducts> {

  // Future<List<Product>> product = [] as Future<List<Product>>;
  List<Product>products =[];

  @override
  Widget build(BuildContext context) {
    print("products here");
    print(products.length);
    print(products.length);

    return Container(
      decoration: BoxDecoration(
        //  color: Colors.amberAccent,
      ),
      child: Column(
        children: [
          Padding(
            padding:
            EdgeInsets.only( left: getProportionateScreenWidth(10)),
            child: Row(
              children:[
                Text("Today's deal",style: mainStyle.sectitle,)],
            ),
          ),

          Container(
            padding: EdgeInsets.all(10.0),
            child :products.length==0 ? FutureBuilder<List<Product>>(
              future: getRecentProducts(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SpinKitThreeBounce(
                    color: Colors.amber,
                    size: 20,
                  );
                }
                if(snapshot.hasData){
                  products = snapshot.data!;
                  return popprodlist();
                }
                return Container(
                  child: Text('No Products'),
                );
              },
            ) : popprodlist(),
          ),
        ],
      ),
    );
  }
  Widget popprodlist()
  {
    /*return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            //products.length,
            2,
                (index) {
              if (!products[index].isPopular)
                return RecentProductCards(products: products[index]);
              return SizedBox
                  .shrink(); // here by default width and height is 0
            },
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
        ],
      ),
    );*/
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 4,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (cc,i){
          return RecentProductCards(products: products[i]);
        }
    );
  }
}
