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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'OtpVerification.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

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
  late String  selectState;
  String userId = "";
  String prevMobile = "";

  _showLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              SizedBox(width: 5.0,),
              Text('Update Profile Details', style: mainStyle.text16White,)
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: mainStyle.mainColor,
        elevation: 0.0,
      ),
      body: FutureBuilder<String?>(
        future: getData("USER_DATA"),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            var data = jsonDecode(snapshot.data!);
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
            return Container(
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
                            SizedBox(height: 20,),
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
                                  selectState = value!;
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
                              maxLines: 3,
                              onSaved: (value){
                                user.address = value;
                                userForm.address = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Shipping Address",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 20,),
                            RaisedButton(
                              onPressed: (){
                                if(_signupForm.currentState!.validate()){
                                  _signupForm.currentState!.save();
                                  if(userForm.prevMobile!=userForm.mobile) {
                                    _mobileVerify(userForm.mobile!);
                                  } else {
                                    _update();
                                  }
                                }
                              },
                              color: mainStyle.secColor,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: (Text('Update',style: mainStyle.text16White)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return SpinKitThreeBounce(
            color: Colors.amber,
            size: 20,
          );
        },
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
          Fluttertoast.showToast(msg: "Profile Updated");
          Navigator.pop(context,"TRUE");
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
}
