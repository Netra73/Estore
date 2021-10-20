import 'package:estore/layouts/PopProducts.dart';
import 'package:estore/layouts/products.dart';
import 'package:estore/layouts/size_config.dart';
import 'package:estore/model/RecentProduct.dart';
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
import 'RecentProducts.dart';
import 'section_title.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import '../model/Product.dart';
import '../config.dart';



class  PopularProducts extends StatefulWidget {
  @override
  _PopularProducts createState() => _PopularProducts();
}

class _PopularProducts extends State<PopularProducts> {

 // Future<List<Product>> product = [] as Future<List<Product>>;
  List<Product>products =[];

var url = Uri.parse("API_URL+'Products/getCatProducts/'+cid");
  // @override
  // void initState() {
  //   super.initState();
  //  getProdData();
  // }
  void getProdData() async {
    //getProducthere("3");
    // var catJson = await CatAPI().getCatBreeds();
    // print(catJson);
    //
    // var catMap = json.decode(catJson);
    setState(() {
     // product = getProduct("1") ;


     // products = product as List<Product>;
    //  getProducthere('2');
    });
  }
  Future<dynamic> getProducthere(String cid) async {
    //final response = await http.get(API_URL+'Products/getCatProducts/'+cid);
    final response = await http.get(url);

    if(response.statusCode == 200){
      var jdata = jsonDecode(response.body);
      var data = jdata['data'];
      for(var details in data){
        String id = details['pid'];
        String name = details['name'];
        String sizeId = details['sizeId'];
        String size = details['size'];
        String rate = details['rate'];
        String offer = details['offer'];
        String thumb = jsonEncode(details['thumb']);

        products.add(Product(title: name,id: id,sizeId: sizeId,size: size,rate: rate,offer: offer,thumb: thumb,isPopular: false,isFavourite: false));
      }
      print("products");
      print(products.length);

    }


  }


@override
  Widget build(BuildContext context) {
// getProducthere("3");
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
                 Text("Popular Products",style: mainStyle.sectitle,)],
            ),
          ),
          //SizedBox(height: getProportionateScreenWidth(20)),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          Container(
            padding: EdgeInsets.all(10.0),
             child :products.length==0 ? FutureBuilder<List<Product>>(
                    future: getProduct("1"),
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
  //       SizedBox(height: 10,),
  // RecentProducts(),
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
          return ProductCards(products: products[i]);
        }
    );
     /* return SingleChildScrollView(
        scrollDirection: Axis.horizontal,


        child: Row(

          children: [
            ...List.generate(
              //products.length,
                    2,
                  (index) {
                if (!products[index].isPopular)
                  return ProductCards(products: products[index]);

                return SizedBox
                    .shrink(); // here by default width and height is 0
              },
            ),
            SizedBox(width: getProportionateScreenWidth(20)),
          ],
        ),
      );*/
  }
  Widget productList() {

      return  Container(
        padding: EdgeInsets.all(10.0),
        child: new GridView.count(
                primary: false,
  shrinkWrap: true,
  crossAxisCount: 2,
  childAspectRatio: 0.85,
  children: List.generate(products.length, (index) {
    return ProductCards(products: products[index]);
  }),
          //),
        ),
      );
      
  }
  Widget productLists() {
    return Container(

      child: GridView.builder(
      itemCount: products.length,


        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          var thumb = jsonDecode(products[index].thumb);
          String thumbImg = thumb[0];
          int offer = 0;
          String mrp = products[index].rate;
          if(products[index].offer!='0'){
            offer = int.parse(products[index].offer);
            double offRate = (offer/100)*int.parse(mrp);
            mrp = offRate.toStringAsFixed(0);
          }
          return Single_prod(
            prod_name: products[index].title,
            prod_pricture: thumb[0],
            prod_old_price: products[index].rate,
            prod_price: mrp,
            prod_index:index,
            product: products,
            prod_offer: offer,
          );
          //return ProductCard(products: products[index]);
        }),
    );


  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;
  final int prod_index;
  final int prod_offer;
  final List<Product> product;
  final bool ispop;
  final bool isfav;

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

              child: Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: SizedBox(
                  width: getProportionateScreenWidth(140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      AspectRatio(
                        aspectRatio: 1.02,
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                              prod_pricture),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                       prod_name,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${prod_price}",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                              height: getProportionateScreenWidth(28),
                              width: getProportionateScreenWidth(28),
                              decoration: BoxDecoration(
                                color: isfav
                                    ? kPrimaryColor.withOpacity(0.15)
                                    : kSecondaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/icons/Heart Icon_2.svg",
                                color: isfav
                                    ? Color(0xFFFF4848)
                                    : Color(0xFFDBDEE4),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

            ),
          )),
    );
  }
}
