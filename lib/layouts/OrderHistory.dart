
import 'dart:collection';
import 'dart:convert';

import 'package:estore/api/getOrderDetails.dart';
import 'package:estore/api/getOrders.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/OrderDetails.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderItems{
  String oid;
  String date;
  String items;
  String total;

  OrderItems(this.oid, this.date, this.items, this.total);

}

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  String uid = "";
  List<OrderItems> orderItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData("USER_DATA").then((value){
      var data = jsonDecode(value!);
      setState(() {
        uid = data['id'];
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
                Icons.format_list_bulleted,
                color: mainStyle.mainColor,
                size: 25,
              ),
              SizedBox(width: 5.0,),
              Text('Order History', style: TextStyle(color: Colors.amber,fontSize: 18),),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(!uid.isEmpty) Container(
                child: FutureBuilder<String?>(
                  future: getOrders(uid),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      var data = jsonDecode(snapshot.data!);
                      if(data["status"]==200){
                        orderItems.clear();
                        var odata = data["data"];
                        for(var od in odata){
                          orderItems.add(OrderItems(od['orderId'], od['orderDate'], od['totalItems'], od['totalAmount']));
                        }

                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: orderItems.length,
                          itemBuilder: (context,i){
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => OrderDetails(orderItems[i].oid)
                                ));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                          Text(" "+orderItems[i].date,style: mainStyle.text14Gray,)
                                        ],
                                      ),
                                      SizedBox(height: 2.0,),
                                      Text("#00"+orderItems[i].oid,style: mainStyle.text16Bold,),
                                      SizedBox(height: 10.0,),
                                      Row(
                                        children: [
                                          Text("\u20B9"+orderItems[i].total,style: mainStyle.text18Rate,),
                                          Text(" ("+orderItems[i].items+" item)",style: mainStyle.text14,)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        );
                      }
                      return Center(child: Text("No orders found ",style: mainStyle.text18,));
                    }
                    return SpinKitThreeBounce(
                      color: Colors.amber,
                      size: 20,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
