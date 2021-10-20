import 'dart:convert';

import 'package:estore/api/MobileVerification.dart';
import 'package:estore/api/UserLogin.dart';
import 'package:estore/api/UserSignup.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/functions/validation.dart';
import 'package:estore/layouts/ForgotPassword.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/model/User.dart';
import 'package:estore/model/UserForm.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'OtpVerification.dart';

class Login extends StatefulWidget {

  bool guest;
  Login(this.guest);

  @override
  _LoginState createState() => _LoginState(guest);
}

class _LoginState extends State<Login> {
 final bool guest;
  _LoginState(this.guest);

  bool login = false;
  bool signup = false;
  bool inValid = false;
  bool signupError = false;
  String errorMsg = "";
  final _loginForm  = GlobalKey<FormState>();
  final _signupForm  = GlobalKey<FormState>();
  LoginForm loginForm = LoginForm();
  UserForm userForm = UserForm();
  User user = User();
  final List<DropdownMenuItem<String>> states = [];
  final String stateitems = '["Andra Pradesh,Arunachal Pradesh","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telagana","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]';
  var stList;

  void _loadState(){
    int no = 0;
    for(var st in stList) {
      states.add(DropdownMenuItem<String>(
        child: Text(st),
        value: st,
      ));
      no++;
    }
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

  @override
  Widget build(BuildContext context) {

    stList = json.decode(stateitems);
    if(states.length<1) {
      _loadState();
    }

    return Scaffold(
      backgroundColor: mainStyle.bgColor,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              !signup ? Text("Login",style: mainStyle.text20,) : Text("Signup",style: mainStyle.text20,),
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
        backgroundColor: mainStyle.bgColor,
        elevation: 0.0,
      ),
      body: Container(
          color: mainStyle.bgColor,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                !signup ? Column(
                  children: [
                    SizedBox(height: 40.0,),
                    if(inValid) Text("Invalid details",style: TextStyle(fontSize: 14,color: Colors.red),),
                    SizedBox(height: 10.0,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: mainStyle.grayBorder,
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                      padding: EdgeInsets.all(15),
                      child: Form(
                        key: _loginForm,
                        child: Column(
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
                            TextFormField(
                              obscureText: true,
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              onSaved: (value){
                                loginForm.password = value;
                              },
                              decoration: InputDecoration(
                                  hintText: "Password"
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.fromLTRB(160.0, 0, 0, 0),
                                child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>ForgotPassword()
                                      ));

                                    },
                                    child: Text("Forgot password?",style: TextStyle(fontSize: 14,color: Colors.amber[600]),textAlign: TextAlign.right,)
                                )),
                            SizedBox(height: 30,),
                            RaisedButton(
                              onPressed: (){
                                if(_loginForm.currentState!.validate()){
                                  _loginForm.currentState!.save();
                                  _login();
                                }
                              },
                              color: mainStyle.mainColor,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: (Text('Login',style: mainStyle.text16White)),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              child: Row(
                                children: [
                                  Text("Don't have an account ? ", style: mainStyle.text16,),
                                  GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          signup = true;
                                        });
                                      },
                                      child: Text("SignUp ", style: TextStyle(fontSize: 16,color: Colors.amber[600],fontWeight: FontWeight.bold),)
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ) :
                Column(
                  children: [
                    SizedBox(height: 10,),
                    if(signupError) Text(errorMsg,style: TextStyle(fontSize: 14,color: Colors.red),),
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
                              validator: (value){
                                return validateName(value!, "Name is required");
                              },
                              onSaved: (value){
                                userForm.name = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Your name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              validator: (value){
                                return emailRequired(value!, "Enter valid email id");
                              },
                              onSaved: (value){
                                userForm.email = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Email id",
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextFormField(
                              validator: (value){
                                return mobileRequired(value!, "Enter valid mobile number");
                              },
                              onSaved: (value){
                                userForm.mobile = value.toString();
                              },
                              decoration: InputDecoration(
                                hintText: "Mobile number",
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            TextFormField(
                              validator: (value){
                                return fieldRquired(value!,"Enter Password");
                              },
                              obscureText: true,
                              onSaved: (value){
                                userForm.password = value;
                              },
                              decoration: InputDecoration(
                                  hintText: "Password"
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 20,),
                            RaisedButton(
                              onPressed: (){
                                if(_signupForm.currentState!.validate()){
                                  _signupForm.currentState!.save();
                                  _mobileVerify(userForm.mobile!);
                                }
                              },
                              color: mainStyle.mainColor,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: (Text('Submit',style: TextStyle(color: Colors.white,fontSize: 18),)),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              child: Row(
                                children: [
                                  Text("Already have an account ? ", style: mainStyle.text16,),
                                  GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          signup = false;
                                        });
                                      },
                                      child: Text("Login ", style: TextStyle(fontSize: 16,color: Colors.amber[600],fontWeight: FontWeight.bold),)
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
     /* bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.amber[700],
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context,"TRUE");
          },
          child: Container(
              height: guest ? 50.0:0.0,
              padding: EdgeInsets.all(10.0),
              color: mainStyle.secColor,
              child: Center(child: Text('Continue As Guest',style: mainStyle.text20White,)
              )
          ),
        ),
      ),*/
    );
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
            _signup();
          }
        });
      }
    });
  }

  _signup(){
    _showLoading();
    UserSignup(userForm).then((value){
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
        String id = data['id'];
        setData("USER", id).then((value){
          setData("USER_DATA", jsonEncode(data)).then((value){
            Navigator.pop(context,"TRUE");
          });
        });
      }
    });
  }

  _login(){
    _showLoading();
    UserLogin(loginForm).then((value){
      Navigator.pop(context,"FALSE");
      var response = jsonDecode(value!);
      if(response['status'] == 422){
        setState(() {
          inValid = true;
        });
      }
      if(response['status']==200){
        var data = response['data'];
        print("see profile" );
        print(data);
        String id = data['id'];
        String wallet = data['walletBalance'];
        print(wallet);
        setcashbackamt("cashback", wallet);
        setData("USER", id).then((value){
          setData("USER_DATA", jsonEncode(data)).then((value){
            Navigator.pop(context,"TRUE");
          });
        });
      }
    });
  }
}
