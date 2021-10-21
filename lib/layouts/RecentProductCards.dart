import 'dart:convert';

import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProductDetails.dart';

class RecentProductCards extends StatelessWidget {
  const RecentProductCards({
    Key? key,
    // this.prod_name,
    // this.prod_pricture,
    // this.prod_old_price,
    // this.prod_price,
    // required this.prod_index,
    // required this.product,
    // required this.prod_offer,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.products,
  }) : super(key: key);
  // final prod_name;
  // final prod_pricture;
  // final prod_old_price;
  // final prod_price;
  // final int prod_index;
  // final int prod_offer;
  // final List<Product> product;

  final double width, aspectRetio;
  final Product products;

  @override
  Widget build(BuildContext context) {
    var thumb = jsonDecode(products.thumb);
    String thumbImg = thumb[0];
    int offer = 0;
    String mrp = products.rate;
    if (products.offer != '0') {
      offer = int.parse(products.offer);
      double offRate = (offer / 100) * int.parse(mrp);
      double price = int.parse(mrp) - offRate;
      mrp = price.toStringAsFixed(0);
    }
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      margin: EdgeInsets.all(5.0),
      height: 200.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
          border: mainStyle.grayBorder),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(products)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                thumbImg,
                fit: BoxFit.cover,
                height: 120.0,
              ),
            ),
            Container(
              child: Text(
                products.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '\u20B9' + mrp + ' ',
                        style: mainStyle.text18Rate,
                      ),
                      if (offer > 0)
                        Text(
                          ' \u20B9' + products.rate,
                          style: TextStyle(
                              color: mainStyle.textColor,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
