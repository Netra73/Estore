
import 'package:estore/api/getCategory.dart';
import 'package:estore/api/getProduct.dart';
import 'package:estore/layouts/section_title.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/model/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'displayproducts.dart';




class PopProducts extends StatelessWidget {
   late List<Product> products;
  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        Container(
          child : FutureBuilder<List<Product>>(
            future: getProduct("3"),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return SpinKitThreeBounce(
                  color: Colors.amber,
                  size: 20,
                );
              }
              if(snapshot.hasData){
                products = snapshot.data!;
                return popprodlists(context);

              }
              return Container(
                child: Text('No Products'),
              );
            },
          ),
        ),

      ],
    );
  }

  Widget popprodlists(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          products.length,
              (index) => CategoryCard(
                text: products[index].title,
            picture: products[index].thumb[0],
            press: () {

              // Navigator.push(context, MaterialPageRoute(
              //     builder: (context) => DisplayProducts(cat_index: category[index].id,cat_name: category[index].title,)
              // ));
            },
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
    required this.picture,
  }) : super(key: key);

  final String  text;
  final String  picture;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width:140,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              height: 90,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(picture),
            ),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center,style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
