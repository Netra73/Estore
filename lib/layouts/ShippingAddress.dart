import 'dart:convert';

import 'package:estore/api/MobileVerification.dart';
import 'package:estore/api/SendOtp.dart';
import 'package:estore/api/UserSignup.dart';
import 'package:estore/api/UserUpdate.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/functions/validation.dart';
import 'package:estore/layouts/CheckOut.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/model/User.dart';
import 'package:estore/model/UserForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estore/style/textstyle.dart';

import 'OtpVerification.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  bool login = false;
  bool signup = false;
  bool signupError = false;
  String errorMsg = "";
  final _signupForm  = GlobalKey<FormState>();
  UserForm userForm = UserForm();
  User user = User();
  final List<DropdownMenuItem<String>> states = [];
  final stateitems = ["Andra Pradesh,Arunachal Pradesh","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telagana","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"];
  var stList;
  String?  selectState;
  String userId = "";
  String prevMobile = "";

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
//    stList = json.decode(stateitems);
//    print("SIZE :"+states.length.toString());
//    if(states.length<1) {
//      _loadState();
//    }
    checkData("USER").then((value){
      if(value){
        getData("USER_DATA").then((snapshot){
          var data = jsonDecode(snapshot!);
          setState(() {
            login = true;
            user.id = data['id'];
            user.name = data['name'];
            user.email = data['email'];
            user.mobile = data['mobile'];
            user.city = data['city'];
            user.state = data['state'];
            user.pincode = data['pincode'];
            user.address = data['address'];
            if(stateitems.contains(data['state'])) {
              selectState = data['state'];
              userForm.state = data['state'];
            }
            userForm.id = data['id'];
            userForm.prevMobile = data['mobile'];
            userForm.prevEmail = data['email'];
          });
        });
      } else {
        getData("SHIPPING_ADDRESS").then((value){
          if(value!=null){
            var data = jsonDecode(value);
            user.name = data['name'];
            user.email = data['email'];
            user.mobile = data['mobile'];
            user.city = data['city'];
            user.pincode = data['pincode'];
            user.state = data['state'];
            user.address = data['address'];
            if(stateitems.contains(data['state'])) {
              selectState = data['state'];
              userForm.state = data['state'];
            }
            userForm.prevMobile = data['mobile'];
            userForm.prevEmail = data['email'];
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//    stList = json.decode(stateitems);
    //states.clear();
   //_loadState();
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              SizedBox(width: 5.0,),
              Text('Shipping Address', style: TextStyle(color: Colors.amber,fontSize: 18),),
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
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(signupError) Text(errorMsg,style: TextStyle(fontSize: 14,color: Colors.red),),
              SizedBox(height: 15.0,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: mainStyle.grayBorder,
                    borderRadius: BorderRadius.circular(4.0)
                ),
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _signupForm,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: TextEditingController(text: user.name),
                        validator: (value){
                          return validateName(value!, "Name is required");
                        },
                        onSaved: (value){
                          user.name = value;
                          userForm.name = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Your name",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.email),
                        validator: (value){
                          return emailRequired(value!, "Enter valid email id");
                        },
                        onSaved: (value){
                          user.email = value;
                          userForm.email = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Email id",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.mobile),
                        validator: (value){
                          return mobileRequired(value!, "Enter valid mobile number");
                        },
                        onSaved: (value){
                          user.mobile = value;
                          userForm.mobile = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Mobile number",
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      //SizedBox(height: 20,),
                      TextFormField(
                        controller: TextEditingController(text: user.city),
                        validator: (value){
                          return fieldRquired(value!, "Enter City");
                        },
                        onSaved: (value){
                          user.city = value;
                          userForm.city = value;
                        },
                        decoration: InputDecoration(
                          hintText: "City",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      DropdownButton<String>(
                        hint: Text('State'),
                        items: stateitems.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: selectState,
                        isExpanded: true,
                        onChanged: (value){
                          _signupForm.currentState!.save();
                          userForm.state = value;
                          setState(() {
                            selectState = value;
                          });
                        },
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.pincode),
                        validator: (value){
                          return fieldRquired(value!, "Enter Pincode");
                        },
                        onSaved: (value){
                          user.pincode = value;
                          userForm.pincode = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Pincode",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.address),
                        validator: (value){
                          return fieldRquired(value!, "Enter Address");
                        },
                        maxLines: 2,
                        onSaved: (value){
                          user.address = value;
                          userForm.address = value;
                        },

                        decoration: InputDecoration(
                          hintText: "Shipping Address",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      RaisedButton(
                        onPressed: (){
                          if(_signupForm.currentState!.validate()){
                            _signupForm.currentState!.save();
                            if(userForm.prevMobile!=userForm.mobile){
                              if(login){
                                _mobileVerify(userForm.mobile!);
                              } else {
                                _sendOtp(userForm.mobile!);
                              }
                            } else if(login){
                              _update();
                            } else {
                              _gotoCheckout();
                            }
                          }
                        },
                        color: mainStyle.mainColor,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: (Text('Continue',style: TextStyle(color: Colors.white,fontSize: 18),)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _update(){
    _showLoading();
    UserUpdate(userForm).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value!);
      if(response['status'] == 422){
        setState(() {
          signupError = true;
          errorMsg = response['message'];
        });
      }
      if(response['status'] == 200){
        var data = response['data'];
        setData("USER_DATA", jsonEncode(data)).then((value){
          _gotoCheckout();
        });
      }
    });
  }

  _mobileVerify(String mobile){
    _showLoading();
    MobileVerification(mobile).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value!);
      if(response['status'] == 422){
        setState(() {
          signupError = true;
          errorMsg = response['message'];
        });
      }
      if(response['status'] == 200){
        var data = response['data'];
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>OtpVerification(data['mobile'],data['otp'].toString())
        )).then((value){
          if(value!=null){
            _update();
          }
        });
      }
    });
  }

  _sendOtp(String mobile){
    _showLoading();
    SendOtp(mobile).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value!);
      if(response['status'] == 200){
        var data = response['data'];
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>OtpVerification(data['mobile'],data['otp'].toString())
        )).then((value){
          if(value!=null){
            _gotoCheckout();
          }
        });
      }
    });
  }

  _gotoCheckout(){
    _showLoading();
    var shippingAddress = {
      'name' : userForm.name,
      'email':userForm.email,
      'mobile':userForm.mobile,
      'city':userForm.city,
      'state':userForm.state,
      'pincode':userForm.pincode,
      'address':userForm.address,
    };

    setData("SHIPPING_ADDRESS", jsonEncode(shippingAddress)).then((value){
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => CheckOut()));
//      Navigator.push(context, MaterialPageRoute(
//          builder: (context)=>CheckOut()
//      ));
    });
  }
}
