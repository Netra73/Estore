import 'dart:collection';
import 'dart:convert';
//import 'dart:html';

import 'package:estore/api/getProduct.dart';
import 'package:estore/api/getSingleProduct.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/Cart.dart';
import 'package:estore/model/ProductColor.dart';
import 'package:estore/model/ProductSize.dart';
import 'package:flutter/material.dart';
import '../model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;


class ProductDetails extends StatefulWidget {

  Product item;
  ProductDetails(this.item);

  @override
  _productDetailsState createState() => _productDetailsState(item);
}

class _productDetailsState extends State<ProductDetails> {
  int isSelected = 0;
String clr ="";
String clrCode ="";
  Product data;

  String cid = "";
  int qnt = 1;
  int shadeClr =0;
  String shadeClrCode ='';
  _productDetailsState(this.data);

  _showLoading() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double offer = 0;
    String mrp = data.rate;
    if(data.offer!='0'){
      offer = double.parse(data.offer);
      double offRate = (offer/100)*int.parse(mrp);
      double price = int.parse(mrp) - offRate;
      mrp = price.toStringAsFixed(0);
    }

    var thumb = jsonDecode(data.thumb);
    String thumbImg = thumb[0];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Details', style: TextStyle(color: Colors.amber,fontSize: 18),),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close,size: 25,color: Colors.black87,),
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                //Navigator.push(context, MaterialPageRoute(
                                  //builder: (context) =>imageView(widget.item.thumb)
                                // ));
                                },
                                child: Hero(
                                  tag : data,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Image(
                                        image: NetworkImage(thumbImg),
                                        width: 80,
                                        height: 80
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
                                      Text(data.title, style: mainStyle.text18,),
                                      Text('Size : '+data.size, style: mainStyle.text14,),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text('\u20B9 '+(double.parse(mrp)*qnt).toString(), style: mainStyle.text20Rate,),
                                          if(offer>0)
                                            Text(' \u20B9'+data.rate, style: TextStyle(color: mainStyle.textColor,fontSize: 14,decoration: TextDecoration.lineThrough),),
                                          SizedBox(width: 10.0,),
                                          if(qnt != 1) Text('for '+qnt.toString(),style: mainStyle.text14,)
                                        ],
                                      ),
                                      Text('In stock', style: TextStyle(color: Colors.green,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(width: 1.0, color: Colors.grey),
                                        left: BorderSide(width: 1.0, color: Colors.grey),
                                        right: BorderSide(width: 1.0, color: Colors.grey),
                                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                                      ),
                                      borderRadius: BorderRadius.circular(2.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              if(qnt>1){
                                                qnt--;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.black38,
                                            size: 20,
                                          ),
                                        ),
                                        width: 40,
                                        height: 32,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        color: Colors.amber[100],
                                        width: 50.0,
                                        height: 32.0,
                                        child: Center(child: Text(qnt.toString(),style: mainStyle.text16,)),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              qnt++;
                                            });
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black38,
                                            size: 20,
                                          ),
                                        ),
                                        width: 40,
                                        height: 32,
                                      ),
                                    ],
                                  ),
                                ),
                                FutureBuilder(
                                  future: checkCart(data.sizeId),
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      if(snapshot.data != null){
                                        return Text('In Cart',style: mainStyle.text14Bold,);
                                      } else {
                                        return RaisedButton(
                                          onPressed: (){
                                            setCart(data.sizeId,qnt.toString(),shadeClrCode).then((value){
                                              setState(() {
                                              });
                                            });
                                          },
                                          color: mainStyle.mainColor,
                                          child: Text('Add to Cart',style: mainStyle.text16White,),
                                        );
                                      }
                                    } else {
                                      return SizedBox(width: 10,);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: FutureBuilder<String?>(
                                future: getSingleProduct(data.sizeId),
                                builder: (context,snapshot){
                                  if(snapshot.hasData) {
                                    var pdata = jsonDecode(snapshot.data!);
                                    var color = pdata['shades'];
                                    print(color);
                                    var size = pdata['size'];
                                    List<ProductSize> pSize = [];
                                    pSize.clear();
                                    for(var sz in size){
                                      String sizeId = sz['sizeId'];
                                      String sizeName = sz['size'];

                                      if(sizeName!=data.size) {
                                        pSize.add(ProductSize(sizeId, sizeName));
                                      }
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if(pSize.length>0)Text('Available Size :',style: mainStyle.text12,),
                                              Text('Available Shades :',style: mainStyle.text12,),
                                      /* Container(
                                                height: 50,
                                                width: 250,
                                                 child: ListView.builder(
                                                     scrollDirection: Axis.horizontal,
                                                     //shrinkWrap: true,
                                                   itemCount:color.length,
                                                  itemBuilder: (cc,i){
                                                        clr = color[i]['shadeColor'];
                                                        //clrname = color[i]['shadeName'];
                                                      // String clrId = color[i]['shadeId'];
                                                       print(clr);
                                                      // print(clrId);
                                                      shadeClr = int.parse("0xff"+clr.substring(1));

                                                       return GestureDetector(
                                                         onTap: (){
                                                           print(isSelected);
                                                           setState(() {
                                                             String clrId = color[i]['shadeId'];
                                                             print(clrId);
                                                             clrCode = color[i]['shadeColor'];
                                                             print(clrCode);
                                                             shadeClrCode =clrCode.substring(1);
                                                             print(shadeClrCode);
                                                             isSelected = i;
                                                           });
                                                         },
                                                         child: Container(
                                                           margin:EdgeInsets.only(right:5.0,left:5.0),
                                                           padding: EdgeInsets.all(25),
                                                           decoration: BoxDecoration(
                                                             border: Border.all(color: i== isSelected ? Colors.black : Colors.transparent,width:2),
                                                             borderRadius: BorderRadius.circular(100),
                                                             color: Color(shadeClr),
                                                         // color: isSelected ? kDarkTitleColor : Colors.transparent,
                                                      ),

                                                 ),
                                                       );
                                                }
                                                ),
                                              ),*/
                                            ],
                                          ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(pSize.length>0)Container(
                                            width: 90,
                                            height: 27,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: pSize.length,
                                                itemBuilder: (context,i){
                                                  return GestureDetector(
                                                      onTap: (){
                                                        _showLoading();
                                                        getSingleProduct(pSize[i].sizeId).then((value){
                                                          Navigator.pop(context);
                                                          var rdata = jsonDecode(value!);
                                                          // var prdata = rdata['data'];
                                                          var pr = rdata['product'];
                                                          String id = pr[0]['pid'];
                                                          String name = pr[0]['name'];
                                                          String sizeId = pr[0]['sizeId'];
                                                          String size = pr[0]['size'];
                                                          String rate = pr[0]['rate'];
                                                          String offer = pr[0]['offer'];
                                                          String thumb = jsonEncode(pr[0]['thumb']);
                                                          var prData = Product(title: name,id: id,sizeId: sizeId,size: size,rate: rate,offer: offer,thumb: thumb,isPopular: false,isFavourite: false);
                                                          setState(() {
                                                            data = prData;
                                                          });
                                                        });
                                                      },
                                                      child: sizeList(pSize[i]));
                                                }),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 180,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                //shrinkWrap: true,
                                                itemCount:color.length,
                                                itemBuilder: (cc,i){
                                                  clr = color[i]['shadeColor'];
                                                  //clrname = color[i]['shadeName'];
                                                  // String clrId = color[i]['shadeId'];
                                                  print(clr);
                                                  // print(clrId);
                                                  shadeClr = int.parse("0xff"+clr.substring(1));

                                                  return GestureDetector(
                                                    onTap: (){
                                                      print(isSelected);
                                                      setState(() {
                                                        String clrId = color[i]['shadeId'];
                                                        print(clrId);
                                                        clrCode = color[i]['shadeColor'];
                                                        print(clrCode);
                                                        shadeClrCode =clrCode.substring(1);
                                                        print(shadeClrCode);
                                                        isSelected = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      margin:EdgeInsets.only(right:2.0,left:2.0),
                                                     padding: EdgeInsets.all(25),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: i== isSelected ? Colors.black54 : Colors.transparent,width:3),
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: Color(shadeClr),
                                                        // color: isSelected ? kDarkTitleColor : Colors.transparent,
                                                      ),

                                                    ),
                                                  );
                                                }
                                            ),
                                          ),
                                            ],
                                        ),
                                       // if(pSize.length>0)
                                         /* Container(
                                            height: 27,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: pSize.length,
                                                itemBuilder: (context,i){
                                                  return GestureDetector(
                                                      onTap: (){
                                                        _showLoading();
                                                        getSingleProduct(pSize[i].sizeId).then((value){
                                                          Navigator.pop(context);
                                                          var rdata = jsonDecode(value);
                                                          // var prdata = rdata['data'];
                                                          var pr = rdata['product'];
                                                          String id = pr[0]['pid'];
                                                          String name = pr[0]['name'];
                                                          String sizeId = pr[0]['sizeId'];
                                                          String size = pr[0]['size'];
                                                          String rate = pr[0]['rate'];
                                                          String offer = pr[0]['offer'];
                                                          String thumb = jsonEncode(pr[0]['thumb']);
                                                          var prData = Product(title: name,id: id,sizeId: sizeId,size: size,rate: rate,offer: offer,thumb: thumb,isPopular: false,isFavourite: false);
                                                          setState(() {
                                                            data = prData;
                                                          });
                                                        });
                                                      },
                                                      child: sizeList(pSize[i]));
                                                }),
                                          ),*/
                                        SizedBox(height: 10,),
                                        SizedBox(height: 10,),
                                        Text('Description',style: mainStyle.text14Bold,),
                                        Html(
                                            data: pdata['description'],
                                          ),
                                      ],
                                    );
                                  } else {
                                    return SpinKitThreeBounce(
                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }
                                },
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                cartQnt(data.sizeId).then((value) {
                  if(value==0){
                    setCart(data.sizeId, qnt.toString(),shadeClrCode).then((value){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Cart()
                      ));
                    });
                  } else {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Cart()
                    ));
                  }
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.amber[600],
                      padding: EdgeInsets.all(15.0),
                      child: Center(child: Text('BUY NOW',style: mainStyle.text18,)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class sizeList extends StatelessWidget {
  ProductSize pSize;
  sizeList(this.pSize);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 5.0),
        child: Text(pSize.size,style: mainStyle.text14,),
        padding: EdgeInsets.fromLTRB(9, 4, 9, 2),
        decoration: BoxDecoration(
            border: mainStyle.grayBorder,
            borderRadius: BorderRadius.circular(2)
        ),
      ),
    );
  }

}
