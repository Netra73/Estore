import 'dart:convert';

import 'package:estore/api/SearchProduct.dart';
import 'package:estore/layouts/ImageView.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ProductDetails.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final searchForm  = GlobalKey<FormState>();
  List<Product> product = [];
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        backgroundColor: mainStyle.mainColor,
        title: Container(
          child: Row(
            children: [
              Text('E-Store',style: mainStyle.text20White,),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
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
                      Icons.search,
                      color: mainStyle.mainColor,
                      size: 25.0,
                    ),
                    Expanded(
                      child: Form(
                        key: searchForm,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: TextEditingController(text: searchKey),
                              autofocus: true,
                              validator: (value){
                                return null;
                              },
                              onFieldSubmitted: (value){
                                setState(() {
                                  searchKey = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                contentPadding: EdgeInsets.all(5.0),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(!searchKey.isEmpty) Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FutureBuilder<List<Product>>(
                        future: SearchProduct(searchKey),
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
                            child: Text('No results for '+searchKey),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
            ),
          ],

        ),
      ),
    );
  }

  ListView productList() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: product.length,
        itemBuilder: (context, i){

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

          return GestureDetector(
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
