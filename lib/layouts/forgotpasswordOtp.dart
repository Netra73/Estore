import 'dart:convert';

import 'package:estore/api/UserLogin.dart';
import 'package:estore/api/UserOtpVerfiy.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/functions/validation.dart';
import 'package:estore/layouts/launchproduct.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgotOtpVerification extends StatefulWidget {
  String mobile,otp,userid;

  ForgotOtpVerification(this.mobile, this.otp,this.userid);

  @override
  _ForgotOtpVerification createState() => _ForgotOtpVerification(mobile,otp,userid);
}

class _ForgotOtpVerification extends State<ForgotOtpVerification> {
  String mobile,otp,userid;

  _ForgotOtpVerification(this.mobile, this.otp,this.userid);

  final _otpForm  = GlobalKey<FormState>();
  String otpValue = "";
  bool invalid = false;
  LoginForm loginForm = LoginForm();
  bool inValid = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black87,),
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: mainStyle.bgColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        color: mainStyle.bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.0,),
              Center(
                child: Text("OTP Verification",style: TextStyle(fontSize: 25.0,color: mainStyle.secColor),),
              ),
              SizedBox(height: 50.0,),
              Center(
                child: Container(
                    child: Text("Enter One Time Password sent \n to +91 "+mobile,style: mainStyle.text16,textAlign: TextAlign.center,)
                ),
              ),
              SizedBox(height: 50.0,),
              if(invalid)  Center(child: Text("Invalid OTP",style: TextStyle(fontSize: 14,color: Colors.red),),),
              if(invalid) SizedBox(height: 10.0,),
              Center(
                child: Container(
                  width: 200.0,
                  child: Form(
                    key: _otpForm,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          validator: (value){
                            return validateName(value!, "Enter OTP");
                          },
                          onSaved: (value){
                            otpValue = value!;
                          },
                          style: TextStyle(
                              fontSize: 30.0,
                              color: mainStyle.textColor
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child:
                RaisedButton(
                  onPressed: (){
                    if(_otpForm.currentState!.validate()){
                      _otpForm.currentState!.save();
                      if(otp!=otpValue){
                        setState(() {
                          invalid = true;
                        });
                      } else {
                        //Navigator.pop(context,"TRUE");
                        loginForm.userid = userid;
                        _login();

                      }

                    }
                  },
                  color: mainStyle.mainColor,
                  padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
                  child: (Text('Submit',style: TextStyle(color: Colors.white,fontSize: 18),)),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                child: Text("Resend OTP",style: mainStyle.text16,),
              )
            ],
          ),
        ),
      ),
    );
  }
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
  _login(){
    _showLoading();
    UserOtpVerify(loginForm).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value!);
      if(response['status'] == 422){
        setState(() {
          inValid = true;
        });
      }
      else{
        var data = response['data'];
        String id = data['id'];
        print("response in otp");
        print(response);

        setData("USER", id).then((value){
          setData("USER_DATA", jsonEncode(data)).then((value){
            //Navigator.pop(context,"TRUE");
           // _goHome();
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
            //Navigator.pop(launchproduct.\,"TRUE");
          });
        });
      }
    });
  }
  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return launchproduct();
    },
  );

  void _goHome() {
    Navigator.pushAndRemoveUntil(context, _homeRoute, (Route<dynamic> r) => false);
  }
}
