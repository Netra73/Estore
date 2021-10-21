import 'dart:convert';

import 'package:estore/api/ApplyPromocode.dart';
import 'package:estore/api/PlaceOrder.dart';
import 'package:estore/api/getCart.dart';
import 'package:estore/api/getSetting.dart';
import 'package:estore/api/getUser.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/OrderDetails.dart';
import 'package:estore/layouts/ShippingAddress.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'HomeDashboard.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String cartString = '';
  String paymentMethod = 'Online';
  List<Product> product = [];
  String totalItem = '';
  String paymentstatus = '';
  String paymentId = '';
  String promocode = '';
  String prodname = '';
  String promobtntext = 'APPLY';
  int totalAmt = 0;
  int initialtotalAmt = 0;
  String cashbackamt = '';
  String cashbackapply = '';
  String cashbackamtmax = '';
  String walletbalance = '0';
  String sendpromocode = '';
  String sendpromorate = '';
  String sendcashback = '0';
  String sendcashbackapplied = '0';
  String errormsg = '';
  String clr = '';
  late Product data;

  int loyalty_points = 2000;
  int deducted_amount = 0;
  int rwdAply = 0;
  int rwdAmt = 0;
  int shipAmt = 0;
  int blncPnts = 0;
  int grandTotal = 0;
  int grandTotalPayable = 0;
  bool ready = false;
  bool loading = false;
  bool applycode = false;
  var productMap = Map<String, Map<String, String>>();
  var address;
  //Razorpay _razorpay;
  LoginForm loginForm = LoginForm();
  bool _value = false;
  bool user = false;

  _showLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: loading,
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

  _errorDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 250.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              "Failed !",
                              style: mainStyle.text20Rate,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "If your amount is debited, it will be refunded to your account.",
                              textAlign: TextAlign.center,
                              style: mainStyle.text14,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.grey[100],
                              child: Text(
                                'OK',
                                style: mainStyle.text18Rate,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _promocodeerrorDialog(String msg, String title) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 250.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              title,
                              style: mainStyle.text20Rate,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: mainStyle.text14,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.grey[100],
                              child: Text(
                                'OK',
                                style: mainStyle.text18Rate,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _cashbackdialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 250.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.amber.shade800,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              "Congratulations!!",
                              style: mainStyle.text20Rate,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "You have just earned a cashback of \u20B9 " +
                                  cashbackamt,
                              textAlign: TextAlign.center,
                              style: mainStyle.text14,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                //Navigator.pop(context);
                                // async {
                                // Save the user preference
                                //await
                                // setcashbackamt("cashback",cashbackamt);
                                // Refresh
                                setState(() {
                                  sendcashback = cashbackamt;
                                });
                                //  sendcashbackapplied = walletbalance;
                                _placeOrder();
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.grey[100],
                              child: Text(
                                'OK',
                                style: mainStyle.text18Rate,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _successDialog(String oid, bool cashback) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 300.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Icon(
                                Icons.check_circle,
                                color: mainStyle.mainColor,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              "Success",
                              style: mainStyle.text20,
                            ),
                            Text(
                              "Order ID : " + oid,
                              style: mainStyle.text14,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            (cashback)
                                ? Text(
                                    "You have just earned a cashback of \u20B9 " +
                                        cashbackamt,
                                    textAlign: TextAlign.center,
                                    style: mainStyle.text14,
                                  )
                                : Container(),
                            Text(
                              "Thank you. We will send a confirmation \nwhen your order ships.",
                              textAlign: TextAlign.center,
                              style: mainStyle.text14,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                //openCheckout;
                                _getWallet();
                                _applypoints();
                                Navigator.pop(context, oid);
                                //  Navigator.push(context, MaterialPageRoute(
                                //      builder: (context) => OrderDetails(oid)
                                //  ));
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.grey[100],
                              child: Text(
                                'View Invoice',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.amber),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeDashboard()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderDetails(oid)))
            .then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeDashboard()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
    getuserdata();
    _getUser();
    getSetting();
    _applypoints();
    /* _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);*/
    _getWallet();
    getCart().then((value) {
      if (value != null) {
        cartString = value;
        getCartProduct(cartString).then((pvalue) {
          print(getCartProduct(cartString));
          print(getCartProduct(cartString));
          product = pvalue;
          print(pvalue);
          print("prod name");
          //print(pvalue['title']);

          getTotal(product).then((total) {
            setState(() {
              totalAmt = total;
              totalItem = product.length.toString();
            });
            _getshippingamount();
          });
        });
      }
    });
    //});
  }

  _getWallet() {
    // _showLoading();
    getData("USER_DATA").then((value) {
      if (value != null) {
        var data = jsonDecode(value);
        String uid = data['id'];
        walletbalance = data['walletBalance'];

        print("wallet from server");

        print(walletbalance);
      }
    });
  }

  _getUser() {
    // _showLoading();
    getData("USER_DATA").then((value) {
      if (value != null) {
        var data = jsonDecode(value);
        String uid = data['id'];
        String name = data['name'];
        print(name);
      }
    });
  }

  //Razor pay code
  @override
  void dispose() {
    super.dispose();
    //_razorpay.clear();
  }

  void openCheckout() async {
    double amount = grandTotal.toDouble() * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount.toString(),
      'name': 'Estore',
      'description': prodname,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      //_razorpay.open(options);
    } catch (e) {
      print("Razor error");
      print(e);
    }
  }

  /* void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment was Successful! Thank you! ", timeInSecForIos: 4);
      paymentId = response.paymentId;
      paymentstatus = '1';
    int offer = 0;
    offer = int.parse(cashbackamt);

    double offRate = (offer/100)*(grandTotal);
    int cash = offRate.toInt();
      cashbackamt = cash.toString();
      if(grandTotal >= int.parse(cashbackapply))
        {
           // _cashbackdialog();

          setState((){
            sendcashback = cashbackamt;

          });

        }
      // else
      //   {

         sendcashbackapplied = walletbalance;
          _placeOrder();
     //   }




  }*/

  /* void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
    if(response.code.toString() == "2")
      {

      }
    else {
      _errorDialog();
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName , timeInSecForIos: 4);
  }*/
  //Razor pay code ends..

  Future<int> getTotal(product) async {
    int total = 0;
    await product.forEach((item) {
      cartQnt(item.sizeId).then((value) {
        // cartClr(item.sizeId).then((clr) {
        //print(clr);
        int offer = 0;
        String mrp = item.rate;
        double off = 0.0;
        if (item.offer != '0') {
          offer = int.parse(item.offer);
          double offRate = (offer / 100) * int.parse(mrp);
          off = int.parse(mrp) - offRate;
          double price = int.parse(mrp) - offRate;
          mrp = price.toStringAsFixed(0);
        }
        total = total + int.parse(mrp) * value;
        print(total);
        int subTotal = int.parse(mrp) * value;
        var tempMap = Map<String, String>();
        tempMap["productName"] = item.title;
        tempMap["sizeId"] = item.sizeId;
        tempMap["rate"] = item.rate;
        tempMap["offer"] = off.toStringAsFixed(0);
        tempMap["sellPrice"] = mrp;
        tempMap["qnt"] = value.toString();
        cartClr(item.sizeId).then((clr) {
          tempMap['color'] = clr.toString();
          print(clr);
          tempMap["total"] = subTotal.toString();
          tempMap["size"] = item.size;

          var thumb = jsonDecode(item.thumb);
          tempMap["thumb"] = thumb[0];
          prodname += item.title;

          productMap[item.id] = tempMap;
          print(tempMap);
        });
      });
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        backgroundColor: mainStyle.mainColor,
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
                width: 10.0,
              ),
              Text(
                'Checkout',
                style: TextStyle(color: Colors.amber, fontSize: 18),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: mainStyle.mainColor,
                padding: EdgeInsets.all(10.0),
                child: ready
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          child: Text(
                                    'Total items : ',
                                    style: mainStyle.text16,
                                  ))),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(totalItem,
                                          style: mainStyle.text16)),
                                  SizedBox(
                                    width: 10.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          child: Text(
                                    'Total Item Amount : ',
                                    style: mainStyle.text16,
                                  ))),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        if (applycode)
                                          Text(
                                            initialtotalAmt.toString() + ".0",
                                            style: TextStyle(
                                                color: mainStyle.textColor,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(totalAmt.toString() + ".0",
                                            style: mainStyle.text16),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          child: Text(
                                    'Shipping Charge : ',
                                    style: mainStyle.text16,
                                  ))),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(shipAmt.toString() + '.0',
                                          style: mainStyle.text16)),
                                  SizedBox(
                                    width: 10.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              /* Row(
                          children: [
                            Expanded(
                                child: Container(
                                child: Text('Wallet Balance: ',style: mainStyle.text16,))
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: Text(walletbalance+".0", style: mainStyle.text16)
                            ),
                            SizedBox(width: 10.0,)
                          ],
                        ),
                        Row(
                          children: [
                        Expanded(
                            child: Container(
                       child: Text('Wallet amount is applied if your order is above '+cashbackamtmax,style: TextStyle(fontSize: 10.0,color: Colors.grey,fontStyle: FontStyle.italic),)
                        )
                        ),
                        ],
                        ),

                        SizedBox(height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Expanded(
                               child: Container(
                                height: 30.0,
                                   //padding: EdgeInsets.all(10.0),
                                //  width: 100.0,

                                  child: TextField(decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                    hintText: "Enter Promocode",
                                    hintStyle: mainStyle.text14,
                                    border: OutlineInputBorder(),
                                  ),

                                    onChanged: (value) => {
                                    promocode = value.toString(),
                                    },
                                    readOnly: applycode,
                                  ),
                               ),
                             ),
                       // SizedBox(width:20.0,),
                            Container(
                              padding: EdgeInsets.all(15.0),

                                child: InkWell(
                                  onTap: (){
                                      print("see pcode");
                                      print(promocode);
                                      if(!applycode) {
                                        if(promocode == '')
                                          {
                                            setState(() {
                                              errormsg = 'Promocode cannot be empty';
                                            });
                                          }
                                        else {
                                          errormsg = '';
                                          _applypromocode(promocode);
                                        }
                                      }
                                  },
                                  child: Text(promobtntext,style: applycode ? mainStyle.text14Gray : mainStyle.promotext14,),
                                )
                            ),
                            SizedBox(width:20.0,),
                          ],
                        ),
                      Row(
                        children: [
                      Expanded(child: Container(
                         child: Text(errormsg,style: TextStyle(fontSize: 10.0,color: Colors.red),),
                      ),
                      ),

                        ],
                      ),*/
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          child: Text(
                                    'Total Amount : ',
                                    style: mainStyle.text20,
                                  ))),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(grandTotal.toString() + '.0',
                                          style: mainStyle.text20Bold)),
                                  SizedBox(
                                    width: 10.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 1.0,
                              ),
                              //if(loyalty_points>=0)
                              if (blncPnts >= rwdAply)
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            child: Text(
                                      'You Have ' +
                                          blncPnts.toString() +
                                          ' Points',
                                      style: mainStyle.promotext14,
                                    ))),
                                    //   if(loyalty_points == rwdAply)
                                    Container(
                                        child: Text(
                                      "USE",
                                      style: mainStyle.promotext14,
                                    )),
                                    //if(blncPnts ==rwdAply)
                                    Container(
                                        child: Checkbox(
                                      value: this._value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value!;
                                          _applypoints();
                                        });
                                      },
                                    )),
                                    SizedBox(
                                      width: 1.0,
                                    )
                                  ],
                                ),
                              // if(blncPnts == rwdAply)
                              if (blncPnts >= rwdAply)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Equal : ₹' + rwdAmt.toString(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              // if(blncPnts == rwdAply)
                              if (blncPnts >= rwdAply)
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            child: Text(
                                      '₹' +
                                          rwdAmt.toString() +
                                          ' Will be rewarded',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ))),
                                  ],
                                ),
                              SizedBox(
                                height: 5.0,
                              ),
                              if (_value)
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            child: Text(
                                      'Loyalty Points : ',
                                      style: mainStyle.text16,
                                    ))),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text('- ₹' + rwdAmt.toString(),
                                          style: mainStyle.text16),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    )
                                  ],
                                ),
                              SizedBox(
                                height: 5.0,
                              ),
                              if (_value)
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        'Total Payable : ',
                                        style: mainStyle.text20,
                                      ),
                                    )),
                                    Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            grandTotalPayable.toString() + '.0',
                                            style: mainStyle.text20Bold)),
                                    SizedBox(
                                      width: 10.0,
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      )
                    : SpinKitThreeBounce(
                        color: Colors.amber,
                        size: 20,
                      ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FutureBuilder<String?>(
                        future: getData("SHIPPING_ADDRESS"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            address = jsonDecode(snapshot.data!);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Address',
                                  style: mainStyle.text14Gray,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  child: Text(
                                    address['name'],
                                    style: mainStyle.text16,
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  child: Text(
                                    address['email'],
                                    style: mainStyle.text16,
                                  ),
                                ),
                                SizedBox(
                                  height: 17,
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
                                  height: 7,
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
                                  height: 7,
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
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShippingAddress()));
                                        },
                                        color: Colors.grey[200],
                                        padding: EdgeInsets.all(12.0),
                                        child: (Text(
                                          'Change Address',
                                          style: mainStyle.text16,
                                        )),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          }
                          return SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Payment Type',
                                style: mainStyle.text14Gray,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black26),
                                )),
                                child: RadioListTile(
                                  groupValue: paymentMethod,
                                  value: 'Online',
                                  activeColor: Colors.amber,
                                  title: Text(
                                    'Pay now',
                                    style: paymentMethod == 'Online'
                                        ? mainStyle.text20
                                        : mainStyle.text20gray,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      paymentMethod = val.toString();
                                    });
                                  },
                                ),
                              ),
                              RadioListTile(
                                groupValue: paymentMethod,
                                value: 'COD',
                                activeColor: Colors.amber,
                                title: Text(
                                  'Pay on delivery',
                                  style: paymentMethod == 'COD'
                                      ? mainStyle.text20
                                      : mainStyle.text20gray,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    paymentMethod = val.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ready
                        ? RaisedButton(
                            onPressed: () {
                              // _placeOrder();
                              if (paymentMethod == 'COD') {
                                paymentId = '0';
                                paymentstatus = '0';
                                _placeOrder();
                              } else {
                                openCheckout();
                              }
                            },
                            color: mainStyle.secColor,
                            padding: EdgeInsets.fromLTRB(20, 13, 23, 10),
                            child: (Text(
                              'Confirm Order',
                              style: mainStyle.text20White,
                            )),
                          )
                        : Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _applypromocode(String code) {
    _showLoading();
    getData("USER_DATA").then((value) {
      String uid = "";
      if (value != null) {
        var data = jsonDecode(value);
        uid = data['id'];
      }
      Applypromocode(uid, code).then((value) {
        var response = jsonDecode(value!);
        if (response['status'] == 401) {
          setState(() {
            Navigator.pop(context);
            promocode = "";
            _promocodeerrorDialog(
                'Please enter valid promocode', 'Promocode Invalid');
          });
        }
        if (response['status'] == 422) {
          setState(() {
            Navigator.pop(context);
            promocode = "";
            _promocodeerrorDialog(
                'This Promocode has been used.Please try other code!!',
                'Promocode cannot be applied!');
          });
        }
        if (response['status'] == 200) {
          var data = response['data'];
          String rate = data['rate'];
          int offer = 0;
          offer = int.parse(rate);

          double offRate = (offer / 100) * (totalAmt);
          double price = totalAmt - offRate;
          setState(() {
            applycode = true;
            initialtotalAmt = totalAmt;
            totalAmt = price.toInt();
            grandTotal = totalAmt + shipAmt;
            promobtntext = "APPLIED";
            sendpromocode = code;
            sendpromorate = rate;
            if (walletbalance != '0') {
              print(
                  "total gtotal max" + grandTotal.toString() + cashbackamtmax);
              if (grandTotal > int.parse(cashbackamtmax)) {
                grandTotal = grandTotal - int.parse(walletbalance);
                sendcashbackapplied = walletbalance;
              }
            }
          });

          Fluttertoast.showToast(
              msg: "Promocode applied successfully!",
              backgroundColor: Colors.amberAccent,
              textColor: Colors.white,
              timeInSecForIosWeb: 2);
          //return _showLoading();
          Navigator.pop(context);
        }
      });
    });
  }

  Widget getuserdata() {
    return Container(
      child: FutureBuilder<String?>(
          future: getData("USER_DATA"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data!);
              print(data);
              cashbackamt = data['walletBalance'];
            }
            return Text("TODO");
          }),
    );
  }

  _getshippingamount() {
    // _showLoading();
    getData("USER_DATA").then((value) {
      String uid = "";
      if (value != null) {
        var data = jsonDecode(value);
        uid = data['id'];
      }
      getSetting().then((value) {
        var response = jsonDecode(value!);
        if (response['status'] == 401) {
          setState(() {
            // _promocodeerrorDialog();
          });
        }
        if (response['status'] == 200) {
          var data = response['data'];
          String shipapply = data['shipApply'];
          String shipAmount = data['shipAmount'];
          cashbackamt = data['cashBackRate'] ?? '';
          cashbackapply = data['cashBackApply'] ?? '';
          cashbackamtmax = data['cashBackMax'] ?? '';
          // int points = 10;
          print('compare ship amount');
          print(totalAmt);
          print(int.parse(shipapply));

          setState(() {
            if (totalAmt < int.parse(shipapply)) {
              shipAmt = int.parse(shipAmount);
              grandTotal = totalAmt + shipAmt;
              print(totalAmt);
            } else {
              shipAmt = 0;
              grandTotal = totalAmt + shipAmt;
            }

            /* if(walletbalance != '0') {

              print("total gtotal max" + grandTotal.toString() + cashbackamtmax );
                if (grandTotal > int.parse(cashbackamtmax)) {
                  grandTotal = grandTotal - int.parse(walletbalance);
                  sendcashbackapplied = walletbalance;
                }

            }*/
            ready = true;
          });
          //Fluttertoast.showToast(msg: "Promocode applied successfully!",backgroundColor: Colors.amberAccent,textColor: Colors.white,timeInSecForIos: 2);
          //return _showLoading();

        }
      });
    });
  }

  _getUserDetails() {
    // int id = 11;
    //String uid = id.toString();
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
        String id = data['id'];
        print(id);
        String balancePoints = data['balancePoints'];
        print(balancePoints);
        blncPnts = int.parse(balancePoints);
      });
    });
  }

  _applypoints() {
    getData("USER_DATA").then((value) {
      String uid = "";
      if (value != null) {
        var data = jsonDecode(value);
        uid = data['id'];
      }
      getSetting().then((value) {
        var response = jsonDecode(value!);
        if (response['status'] == 401) {
          setState(() {
            // _promocodeerrorDialog();
          });
        }
        if (response['status'] == 200) {
          var data = response['data'];
          String shipapply = data['shipApply'];
          String shipAmount = data['shipAmount'];
          String rewardApply = data['rewardApply'];
          String rewardAmount = data['rewardAmount'];
          cashbackamt = data['cashBackRate'] ?? '';
          cashbackapply = data['cashBackApply'] ?? '';
          cashbackamtmax = data['cashBackMax'] ?? '';
          // int points = 10;
          print('compare ship amount');
          print(totalAmt);
          print(int.parse(shipapply));
          rwdAply = int.parse(rewardApply);
          setState(() {
            if (totalAmt < int.parse(shipapply)) {
              shipAmt = int.parse(shipAmount);
              rwdAmt = int.parse(rewardAmount);
              grandTotalPayable = totalAmt + shipAmt - rwdAmt;
              print(totalAmt);
            } else {
              shipAmt = 0;
              grandTotalPayable = totalAmt + shipAmt - rwdAmt;
            }
            if (grandTotalPayable < 0) {
              grandTotalPayable = 0;
            }

            /*if(walletbalance != '0') {

              print("total gtotal max" + grandTotal.toString() + cashbackamtmax );
              if (grandTotal > int.parse(cashbackamtmax)) {
                grandTotal = grandTotal - int.parse(walletbalance);
                sendcashbackapplied = walletbalance;
              }

            }*/
            ready = true;
          });
        }
      });
    });
  }

  _placeOrder() {
    _showLoading();
    getData("USER_DATA").then((value) {
      String uid = "";
      bool cashback = false;
      if (value != null) {
        var data = jsonDecode(value);
        uid = data['id'];
      }
      var orderData = {
        'uid': uid,
        'totalItems': totalItem,
        'subTotal': totalAmt,
        'shipping': shipAmt,
        'trnCharge': '0',
        'codCharge': '0',
        'loyalty_points': loyalty_points,
        'deducted_amount': rwdAmt,
        'totalAmount': grandTotal,
        'paymentType': paymentMethod,
        'paymentStatus': paymentstatus,
        'paymentId': paymentId,
        'name': address['name'],
        'mobile': address['mobile'],
        'email': address['email'],
        'city': address['city'],
        'state': address['state'],
        'pincode': address['pincode'],
        'address': address['address'],
        'items': jsonEncode(productMap),
        'promoCode': sendpromocode,
        'promoRate': sendpromorate,
        'cashBack': sendcashback,
        'cashBackApply': sendcashbackapplied,
      };
      print("see order");
      print(orderData);
      print(orderData);

      PlaceOrder(orderData).then((value) {
        print("See Order response" + value!);

        Navigator.pop(context);
        var response = jsonDecode(value);
        if (response['status'] == 422) {
          setState(() {
            _errorDialog();
          });
        }
        if (response['status'] == 200) {
          var data = response['data'];
          clearCart().then((value) {
            print(value);
            removeData("SHIPPING_ADDRESS").then((value) {
              /* if(grandTotal >= int.parse(cashbackamt))
                {
                  cashback = true;
                }
              else
                {
                  cashback = false;
                }*/
              _successDialog(data['orderId'], cashback);
              // openCheckout();
            });
          });
        }
      });
    });
  }
}
