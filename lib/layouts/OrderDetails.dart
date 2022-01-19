import 'dart:convert';

import 'package:estore/api/getOrderDetails.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Items {
  final String id;
  final String sizeId;
  final String title;
  final String size;
  final String rate;
  final String qnt;
  final String clr;
  final String total;
  final String thumb;

  Items(this.id, this.sizeId, this.title, this.size, this.rate, this.total,
      this.qnt, this.clr, this.thumb);
}

class OrderDetails extends StatefulWidget {
  String oid;
  OrderDetails(this.oid);

  @override
  _OrderDetailsState createState() => _OrderDetailsState(oid);
}

class _OrderDetailsState extends State<OrderDetails> {
  String oid;
  _OrderDetailsState(this.oid);
  int? clrcode;
  String clr = '';
  var data;
  List<Items> item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Order Details',
                style: mainStyle.text16White,
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: mainStyle.mainColor,
        elevation: 0.0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<String?>(
            future: getOrderDetails(oid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dd = jsonDecode(snapshot.data!);
                data = dd['data'];
                return details();
              }
              return SpinKitThreeBounce(
                color: Colors.amber,
                size: 20,
              );
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView details() {
    item.clear();
    var address = data['shippingAddress'];
    var payment = data['payments'];
    var oItems = data['items'];
    String status = data['status'];
    String readstatus = '';
    switch (status) {
      case "0":
        readstatus = "Your order has been placed successfully!";
        break;

      case "1":
        readstatus = "Order has confirmed";
        break;

      case "1":
        readstatus = "Your order has been Shipped.";
        break;

      case "1":
        readstatus = "Your order has been delivered.";
        break;

      default:
        readstatus = '';
    }

    String payStatus = "Paid";
    if (payment['paymentStatus'] == '0') {
      payStatus = "Pending";
    }

    for (var idetail in oItems) {
      String id = idetail['productId'];
      String name = idetail['productName'];
      String sizeId = idetail['sizeId'];
      String size = idetail['productSize'];
      String rate = idetail['price'];
      String qnt = idetail['qnt'];
      clr = idetail['color'];
      String total = idetail['total'];
      String thumb = idetail['thumb'];
      item.add(Items(id, sizeId, name, size, rate, total, qnt, clr, thumb));
    }
    clrcode = int.parse("0xff" + clr);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: mainStyle.grayBorder,
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 150.0,
                              child: Text(
                                "Order Date ",
                                style: mainStyle.text16,
                              )),
                          Text(
                            data["orderDate"],
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 150.0,
                              child: Text(
                                "Order ID # ",
                                style: mainStyle.text16,
                              )),
                          Text(
                            data["orderId"],
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 150.0,
                              child: Text(
                                "Order Total",
                                style: mainStyle.text16,
                              )),
                          Text(
                            data["totalAmount"] + ".0 (" + data["totalItems"] + " item) ",
                            style: mainStyle.text16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Order Status ",
            style: mainStyle.text16Bold,
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: mainStyle.grayBorder,
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white),
                    child: Text(readstatus,
                        style: TextStyle(color: Colors.green, fontSize: 16.0))),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Items ",
            style: mainStyle.text16Bold,
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: mainStyle.grayBorder,
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white),
                    child: itemsView()),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Shipping Address ",
            style: mainStyle.text16Bold,
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: mainStyle.grayBorder,
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          address['name'] + ' , ' + address['mobile'],
                          style: mainStyle.text16,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        child: Text(
                          address['email'],
                          style: mainStyle.text16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              address['address'],
                              style: mainStyle.text16,
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              address['city'] + ', ',
                              style: mainStyle.text16,
                            ),
                            Text(
                              address['state'] + ' ',
                              style: mainStyle.text16,
                            ),
                            Text(
                              address['pincode'],
                              style: mainStyle.text16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'India',
                              style: mainStyle.text16,
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
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Order Summary ",
            style: mainStyle.text16Bold,
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: mainStyle.grayBorder,
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Item's Total : ",
                            style: mainStyle.text16,
                          ),
                          Text(
                            data["subTotal"] + ".0",
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping : ",
                            style: mainStyle.text16,
                          ),
                          Text(
                            data["shippingCharge"] + ".0",
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Total : ",
                            style: mainStyle.text18Bold,
                          ),
                          Text(
                            '\u20B9' + data["totalAmount"] + ".0",
                            style: mainStyle.text18Rate,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 150.0,
                              child: Text(
                                "Payment Method : ",
                                style: mainStyle.text16,
                              )),
                          Text(
                            payment["paymentType"],
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              width: 150.0,
                              child: Text(
                                "Payment Status : ",
                                style: mainStyle.text16,
                              )),
                          Text(
                            payStatus,
                            style: mainStyle.text16,
                          ),
                        ],
                      ),
                      if (payment["paymentType"] != "COD")
                        Row(
                          children: [
                            Container(
                                width: 150.0,
                                child: Text(
                                  "Payment ID : ",
                                  style: mainStyle.text16,
                                )),
                            Text(
                              payment["paymentId"],
                              style: mainStyle.text16,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ListView itemsView() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: item.length,
        itemBuilder: (context, i) {
          int offer = 0;
          String mrp = item[i].rate;
          String thumbImg = item[i].thumb;

          return Container(
            padding: i > 0
                ? EdgeInsets.fromLTRB(0, 7.0, 0, 7.0)
                : EdgeInsets.fromLTRB(0, 0, 0, 7.0),
            decoration: BoxDecoration(
                border: Border(
              top: i > 0
                  ? BorderSide(width: 1.0, color: Colors.black26)
                  : BorderSide(width: 0.0, color: Colors.white),
            )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Image(
                    image: NetworkImage(thumbImg),
                    width: 60,
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          item[i].title,
                          style: mainStyle.text16,
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          "Size : " + item[i].size,
                          style: mainStyle.text12,
                        ),
                        Text(
                          "Qnt : " + item[i].qnt,
                          style: mainStyle.text12,
                        ),
                        Row(
                          children: [
                            Text("shade:"),
                            Container(
                              width: 20,
                              margin: EdgeInsets.only(right: 20.0, left: 3.0),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                //border: Border.all(),
                                borderRadius: BorderRadius.circular(100),
                                color: clrcode != null ? Color(clrcode!) : null,
                              ),
                            ),
                          ],
                        ),
                        //Text("Points Earned: "+item[i].qnt, style: mainStyle.text12,),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Container(
                  child: Text(
                    '\u20B9' + item[i].total,
                    style: mainStyle.text16,
                  ),
                )
              ],
            ),
          );
        });
  }
}
