import 'dart:convert';

import 'package:estore/functions/validation.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OtpVerification extends StatefulWidget {
  String mobile,otp;

  OtpVerification(this.mobile, this.otp);

  @override
  _OtpVerificationState createState() => _OtpVerificationState(mobile,otp);
}

class _OtpVerificationState extends State<OtpVerification> {
  String mobile,otp;

  _OtpVerificationState(this.mobile, this.otp);

  final _otpForm  = GlobalKey<FormState>();
  String otpValue = "";
  bool invalid = false;

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
                          Navigator.pop(context,"TRUE");
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
}
