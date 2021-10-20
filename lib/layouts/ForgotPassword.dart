import 'package:estore/api/UserForgotPassword.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:estore/style/textstyle.dart';
import 'dart:convert';
import 'package:estore/api/MobileVerification.dart';
import 'package:estore/api/UserLogin.dart';
import 'package:estore/api/UserSignup.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/functions/validation.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/model/User.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forgotpasswordOtp.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _forgotpassform  = GlobalKey<FormState>();
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
                    // Icon(
                    //   Icons.person,
                    // color: mainStyle.mainColor,
                    // size: 25,
                    // ),
                       SizedBox(width: 5.0,),
                     Text('Forgot Password?', style: TextStyle(color: Colors.amber,fontSize: 18),),
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
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20.0),
                 // height: 200.0,
                  child: Form(

                      key: _forgotpassform,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          TextFormField(
                          validator: (value){
                           if (value == null || value.isEmpty) {
                          return 'Email id / Mobile number required';
                          }
                         return null;
                          },
                         onSaved: (value){
                            loginForm.username = value;
                                 },
                         decoration: InputDecoration(
                          hintText: "Email id / Mobile number",
                          ),
                           ),
                         SizedBox(height: 15,),
                          RaisedButton(
                            onPressed: (){
                              if(_forgotpassform.currentState!.validate()){
                                _forgotpassform.currentState!.save();
                                _login();
                              }
                            },
                            color: mainStyle.mainColor,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: (Text('Submit',style: mainStyle.text16White)),
                          ),
                        ],
                ),

            ),
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
  _login() {
    _showLoading();
    UserForgotPassword(loginForm).then((value) {
      Navigator.pop(context);
      var response = jsonDecode(value!);
      print("response check");
      print(response);
      if (response['status'] == 422) {
        setState(() {
          inValid = true;
        });
      }
      if (response['status'] == 200) {
        var data = response['data'];
        String id = data['id'];
        int otp = data['otp'];
        print("response check");
        print(loginForm.username);
        print(otp);

        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ForgotOtpVerification(loginForm.username!,otp.toString(),id)
        ));
      }
    });
  }
}
