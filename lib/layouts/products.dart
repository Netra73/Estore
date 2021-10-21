import 'dart:convert';

import 'package:estore/api/getProduct.dart';
import 'package:estore/layouts/ProductDetails.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

class Products extends StatefulWidget {
  final String cat_index;
  const Products(this.cat_index);

  //const Products({Key key, this.cat_index}) : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Blazer",
      "picture": "assets/images/bboy.jpg",
      "old_price": 120,
      "price": 85,
    },
    {
      "name": "Red dress",
      "picture": "assets/images/bgirl.jpg",
      "old_price": 100,
      "price": 50,
    }
  ];
  List<Product> product = [];
  // final String cat_index;
  //
  //  _ProductsState(
  //  {
  //    this.cat_index,
  //  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: product.length == 0
          ? FutureBuilder<List<Product>>(
              future: getProduct(widget.cat_index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitThreeBounce(
                    color: Colors.amber,
                    size: 20,
                  );
                }
                if (snapshot.hasData) {
                  product = snapshot.data!;
                  return productList();
                }
                return SizedBox.shrink();
              },
            )
          : productList(),
    );
  }

  GridView productList() {
    return GridView.builder(
        itemCount: product.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          var thumb = jsonDecode(product[index].thumb);
          String thumbImg = thumb[0];
          int offer = 0;
          String mrp = product[index].rate;
          if (product[index].offer != '0') {
            offer = int.parse(product[index].offer);
            double offRate = (offer / 100) * int.parse(mrp);
            mrp = offRate.toStringAsFixed(0);
          }
          return Single_prod(
            prod_name: product[index].title,
            prod_pricture: thumb[0],
            prod_old_price: product[index].rate,
            prod_price: mrp,
            prod_index: index,
            product: product,
            prod_offer: offer,
            isfav: false,
            ispop: false,
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;
  final int prod_index;
  final int prod_offer;
  final bool ispop;
  final bool isfav;
  final List<Product> product;

  Single_prod({
    this.prod_name,
    this.prod_pricture,
    this.prod_old_price,
    this.prod_price,
    required this.prod_index,
    required this.product,
    required this.prod_offer,
    required this.isfav,
    required this.ispop,
  });

  @override
  Widget build(BuildContext context) {
    // var thumb = jsonDecode(product.thumb);
    // String thumbImg = thumb[0];
    int offer = 0;
    String mrp = prod_price;
    if (prod_offer != '0') {
      offer = prod_offer;
      double offRate = (offer / 100) * int.parse(mrp);
      mrp = offRate.toStringAsFixed(0);
    }
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(0),
          top: getProportionateScreenWidth(5),
          bottom: getProportionateScreenWidth(5),
          right: 0.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(product[prod_index])));
        },
        child: Card(
          //width: getProportionateScreenWidth(140),
          elevation: 4.0,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.02,
                  child:
                      // Center(
                      Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    // decoration: BoxDecoration(
                    //  color: kSecondaryColor.withOpacity(0.1),
                    //  // color: Colors.white54,
                    //  // borderRadius: BorderRadius.circular(15),
                    // ),
                    child: Center(
                      child: Image.network(prod_pricture),
                    ),
                  ),
                  //),
                ),
              ),
              //SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  prod_name,
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
                    child: Text(
                      '\u20B9' + mrp + ' ',
                      style: mainStyle.text18Rate,
                    ),
                  ),
                  if (offer > 0)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
                      child: Text(
                        ' \u20B9' + prod_price,
                        style: TextStyle(
                            color: mainStyle.textColor,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                  // InkWell(
                  //   borderRadius: BorderRadius.circular(50),
                  //   onTap: () {
                  //
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  //     height: getProportionateScreenWidth(28),
                  //     width: getProportionateScreenWidth(28),
                  //     decoration: BoxDecoration(
                  //       color: isfav
                  //           ? kPrimaryColor.withOpacity(0.15)
                  //           : kSecondaryColor.withOpacity(0.1),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Image.asset(
                  //       "assets/icons/Heart Icon_2.svg",
                  //       color: isfav
                  //           ? Color(0xFFFF4848)
                  //           : Color(0xFFDBDEE4),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
  
    return Card(
      elevation: 5.0,

      child: Hero(
          tag: prod_name,

          child: Material(

            child: InkWell(

              onTap: () {

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductDetails(product[prod_index])
                ));
              },

              child: GridTile(

                  // footer: Container(
                  //   color: Colors.white70,
                    child: Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.0),



                              child: Image.network(
                                prod_pricture,
                                //fit: BoxFit.cover,

                                width: 70,
                                height: 70,
                              ),
                            ),
                          ),




                          SizedBox(height: 20,),
                         Padding(
                           padding: EdgeInsets.all(10.0),
                           child: Text(
                             prod_name,
                             style: TextStyle(fontWeight: FontWeight.bold),
                           ),
                         ),

                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Text('\u20B9'+prod_price+' ', style: mainStyle.text18Rate,),
                              if(prod_offer>0)
                                Text(' \u20B9'+prod_old_price, style: TextStyle(color: mainStyle.textColor,fontSize: 14,decoration: TextDecoration.lineThrough),),
                            ],
                          ),
                        )




                        // subtitle: Text(
                        //   "\$$prod_old_price",
                        //   style: TextStyle(
                        //       color: Colors.black54,
                        //       fontWeight: FontWeight.w800,
                        //       decoration
                        //           :TextDecoration.lineThrough),
                        // ),
                        ],
                      ),
                    ),

                  ),


                ),

            ),
          )
    );
    //);
  }

*/
}
