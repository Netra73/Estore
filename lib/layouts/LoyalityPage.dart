import 'dart:convert';

import 'package:estore/api/PlaceOrder.dart';
import 'package:estore/api/getOrders.dart';
import 'package:estore/api/getSetting.dart';
import 'package:estore/api/getUser.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/Cart.dart';
import 'package:estore/layouts/OrderHistory.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:core';

import 'package:http/http.dart' as http;



class LoyalityPage extends StatefulWidget {
  @override
  _LoyalityPage createState() => _LoyalityPage();
}

class _LoyalityPage extends State<LoyalityPage> {
int blncPnts = 0;
int loyalty_points =2000;
List<OrderItems> orderItems = [];
String uid = "";
int rwdAmt= 0;
@override
void initState() {
  // TODO: implement initState
  super.initState();
  _rewardAmount();
  _getUserDetails();
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
      body: Container(

      ),
    );
  }
_getUserDetails() {
//  int id = 11;
  // String uid = id.toString();
  getData("USER_DATA").then((value) {
    String uid = "";
    if (value != null) {
      var data = jsonDecode(value);
      uid = data['id'];
    }
    getUser(uid).then((value) {
      var response = jsonDecode(value!);
      var data = response['data'];
      print(data);
      setState(() {
        String id = data['id'];
        String balancePoints = data['balancePoints'];
        blncPnts = int.parse(balancePoints);
        print(blncPnts);
      });

    });
  });


}
_rewardAmount()
{

  getData("USER_DATA").then((value){
    String uid = "";
    if(value!=null){
      var data = jsonDecode(value);
      uid = data['id'];
    }
    getSetting().then((value) {
      var response = jsonDecode(value!);
      if(response['status'] == 401){
        setState(() {
        });
      }
      if(response['status'] == 200){
        var data = response['data'];
        String shipapply = data['shipApply'];
        String rewardAmount = data['rewardAmount'];
        print(int.parse(shipapply));
        rwdAmt = int.parse(rewardAmount);

      }
    });

  });
}

}
