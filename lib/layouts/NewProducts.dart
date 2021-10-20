import 'package:estore/api/getCart.dart';
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



class  NewProducts extends StatefulWidget {
  @override
  _NewProducts createState() => _NewProducts();
}

class _NewProducts extends State<NewProducts> {

  List<Product>products =[];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0,left:10.0),
            child: Text("New Products",style: mainStyle.text18,),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child :products.length==0 ? FutureBuilder<List<Product>>(
              future: getRecentProducts(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  products = snapshot.data!;
                  return popprodlist();
                }
                return SpinKitThreeBounce(
                  color: Colors.amber,
                  size: 20,
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
