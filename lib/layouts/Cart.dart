import 'dart:convert';

import 'package:estore/api/getCart.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/CheckOut.dart';
import 'package:estore/layouts/Login.dart';
import 'package:estore/layouts/ShippingAddress.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  String cartString = '';
  List<Product> product = [];
  TextEditingController totalAmt = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart().then((value){
      setState(() {
        if(value!=null){
          cartString = value;
          print(value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: mainStyle.mainColor,
                size: 25,
              ),
              SizedBox(width: 5.0,),
              Text('Your Cart', style: TextStyle(color: Colors.amber,fontSize: 18),),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,size: 25,color: Colors.black87,),
                  ),
                ),
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: cartString.isEmpty ? Container(
          padding: EdgeInsets.all(15.0),
            height: 50.0,
            alignment: Alignment.center,
            child: Text('Cart is empty',style: mainStyle.text18,)) :
        Container(
            child: product.length==0 ? FutureBuilder<List<Product>>
              (
              future: getCartProduct(cartString),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  product = snapshot.data!;
                  print(product);
                  return productList();
                }
                return SpinKitThreeBounce(
                  color: Colors.amber,
                  size: 20,
                );
              },
            ) : productList(),
          ),
      ),
    );
  }

  Column productList() {
    double total = 0.0;
    var buffer = StringBuffer();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: product.length,
            itemBuilder: (context,i){
            var item = product[i];
            int offer = 0;
            String mrp = item.rate;
            if(item.offer!='0'){
              offer = int.parse(item.offer);
              double offRate = (offer/100)*int.parse(mrp);
              double price = int.parse(mrp) - offRate;
              mrp = price.toStringAsFixed(0);
            }

            total = total+double.parse(mrp);
            print(total);
            buffer.write(total.toString());

            var thumb = jsonDecode(item.thumb);
            String thumbImg = thumb[0];

            return FutureBuilder<int>(
              future: cartQnt(item.sizeId),
              builder: (context,val) {
                if(val.hasData){
                  int qnt = val.data!;

                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
//                                        Navigator.push(context, MaterialPageRoute(
//                                            builder: (context) =>imageView(widget.item.thumb)
//                                        ));
                                      },
                                      child: Hero(
                                        tag : item,
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
                                            Text(item.title, style: mainStyle.text16,),

                                            Text('Size : '+item.size, style: mainStyle.text12,),
                                            SizedBox(height: 5,),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
                                                      child: Text('\u20B9'+(int.parse(mrp)*qnt).toString()+'.00 ', style: mainStyle.text18Rate,)),
                                                  SizedBox(width: 1.0,),
                                                  if(qnt != 1) Expanded(child: Text('for '+qnt.toString(),style: mainStyle.text14,)),
                                                 Text('Shade :', style: mainStyle.text16,),
                                                  Container(
                                                     child:FutureBuilder(
                                                       future: cartClr(item.sizeId),
                                                       builder: (context,val){
                                                         if(val.hasData){
                                                           print(val.data);
                                                           String? clr = val.data as String?;
                                                           int clrcode =int.parse("0xff"+clr!);
                                                           return Container(
                                                               margin:EdgeInsets.only(right:2.0,left:2.0),
                                                               padding: EdgeInsets.all(10),
                                                               decoration: BoxDecoration(
                                                                 //border: Border.all(),
                                                                 borderRadius: BorderRadius.circular(100),
                                                                 color: Color(clrcode),
                                                               ),

                                                           );
                                                         }
                                                         return SizedBox(width: 10,);
                                                       },
                                                     )
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Row (
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        decoration: BoxDecoration(
                                            border: mainStyle.grayBorder,
                                            borderRadius: BorderRadius.circular(2.0)
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: GestureDetector(
                                                onTap: (){
                                                  if(qnt>1){
                                                    qnt--;
                                                    setCart(item.sizeId, qnt.toString(),'').then((value){
                                                      setState(() {

                                                      });
                                                    });
                                                  }
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
                                                  qnt++;
                                                  setCart(item.sizeId, qnt.toString(),'').then((value){
                                                    setState(() {

                                                    });
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
                                      OutlineButton.icon(
                                        onPressed: (){
                                          removeCart(item.sizeId).then((value){
                                            cartCount().then((cc){
                                              if(cc==0){
                                                clearCart().then((value){
                                                  setState(() {
                                                    product.removeWhere((element) => element.sizeId==item.sizeId);
                                                    cartString = "";
                                                  });
                                                });
                                              } else {
                                                setState(() {
                                                  product.removeWhere((element) => element.sizeId==item.sizeId);
                                                });
                                              }
                                            });
                                          });
                                        },
                                        color: mainStyle.mainColor,
                                        icon: Icon(Icons.delete_forever,size: 20,color: mainStyle.secColor,),
                                        label: Text('Remove',style: mainStyle.text14,),
                                        borderSide: BorderSide(color: mainStyle.secColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox(height: 10.0,);
              },
            );
          }),
        ),

        SizedBox(height: 5.0,),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Center(child: Text('<< Continue Shopping >>',style: TextStyle(fontSize: 16.0,color: mainStyle.secColor,decoration: TextDecoration.underline),))),],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: mainStyle.secColor,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cart Total',style: mainStyle.text12,),
                      FutureBuilder<String?>(
                        future: getTotal(product),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return Text('\u20B9'+snapshot.data!+'.00',style: TextStyle(fontSize: 20,color: Colors.white),);
                          }
                          return SizedBox(width: 10,);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    _showLoading();
                    checkData("SHIPPING_ADDRESS").then((value){
                      if(!value){
                        checkData("USER").then((value){
                          Navigator.pop(context);
                          if(!value){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>Login(true)
                            )).then((value){
                              if(value!=null){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>ShippingAddress()
                                ));
                              }
                            });
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>ShippingAddress()
                            ));
                          }
                        });
                      } else {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>CheckOut()
                        ));
                      }
                    });
                    },
                  child: Container(
                    color: mainStyle.mainColor,
                    height: 60.0,
                    child: Center(child: Text('Checkout',style: mainStyle.text20White,),),
                  ),
                ),
              )
            ],
          )
        ),
        // SizedBox(height: 2.0,),
        // Container(
        //   color: mainStyle.secColor,
        //
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Container(
        //           margin: EdgeInsets.all(10.0),
        //
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               InkWell(
        //
        //                   onTap:(){
        //
        //                     Navigator.pop(context);
        //                   },
        //                   child: Center(child: Text('Continue Shopping',style: TextStyle(fontSize: 18.0,color: Colors.white),))),
        //
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

Future<String> getTotal(product) async {
  int total = 0;
  await product.forEach((item){
     cartQnt(item.sizeId).then((value){
      int offer = 0;
      String mrp = item.rate;
      print(mrp);
      if(item.offer!='0'){
        offer = int.parse(item.offer);
        double offRate = (offer/100)*int.parse(mrp);
        double price = int.parse(mrp) - offRate;
        mrp = price.toStringAsFixed(0);
      }
      total = total+int.parse(mrp)*value;
      print(total);
    });
  });
  return total.toString();
}













