import 'dart:convert';

import 'package:estore/api/UpdatePassword.dart';
import 'package:estore/api/UserLogin.dart';
import 'package:estore/api/UserOtpVerfiy.dart';
import 'package:estore/api/getUser.dart';
import 'package:estore/functions/UserData.dart';
import 'package:estore/functions/validation.dart';
import 'package:estore/layouts/EditProfile.dart';
import 'package:estore/main.dart';
import 'package:estore/model/LoginForm.dart';
import 'package:estore/model/User.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User user = User();
  String errorMsg = "";
  final passwordForm  = GlobalKey<FormState>();
  late String uid;
  late String oldPassword;
  late String newPassword;
  String cashback = '0';
  LoginForm loginForm = LoginForm();
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

  _changePassword() {
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
                    height: 310.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Change Password",style: mainStyle.text18,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 25.0,
                                    color: mainStyle.mainColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Form(
                              key: passwordForm,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (value){
                                        return validateName(value!, "Enter Current Password");
                                      },
                                      onSaved: (value){
                                        oldPassword = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Current Password",
                                      ),
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                    ),
                                    errorMsg.isEmpty ? SizedBox(height: 10.0,) : Text(errorMsg,style: TextStyle(fontSize: 16.0,color: Colors.red),),
                                    TextFormField(
                                      validator: (value){
                                        return validateName(value!, "Enter New Password");
                                      },
                                      onSaved: (value){
                                        newPassword = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "New Password",
                                      ),
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            RaisedButton(
                              onPressed: (){
                                if(passwordForm.currentState!.validate()){
                                  passwordForm.currentState!.save();
                                  _updatePassword();
                                }
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.grey[100],
                              child: Text('Submit',style: TextStyle(fontSize: 18.0,color: Colors.amber),),
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

  _updatePassword(){
    _showLoading();
    var body = {
      "userId":uid,
      "oldPassword":oldPassword,
      "newPassword":newPassword
    };
    UpdatePassword(body).then((value){
      Navigator.pop(context);
      var data = jsonDecode(value!);
      if(data['status']== 422){
        errorMsg = "Password not matched";
        setState(() {

        });
      }
      if(data['status']== 200){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Password updated");
      }
    });
  }
  _login(){
    _showLoading();
    UserLogin(loginForm).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value!);
      if(response['status'] == 422){
        setState(() {
         // inValid = true;
        });
      }
      if(response['status']==200){
        var data = response['data'];

        print("see profile" );
        print(data);
        String id = data['id'];
        cashback = data['walletBalance'];
        setcashbackamt("cashback", cashback);
        setData("USER", id).then((value){
          setData("USER_DATA", jsonEncode(data)).then((value){
            Navigator.pop(context,"TRUE");
          });
        });
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getData("USER_DATA").then((value) {
   //        if(value != null) {
   //          var data = jsonDecode(value);
   //          String uid = data['id'];
   //       setState(() {
   //            cashback = data['walletBalance'];
   //            print("wallet from server" +  cashback);
   //
   //          });
   //
   //        }

    //     getWallets();

    _updateprofile();

    checkData("USER").then((value){
      if(!value){
        Navigator.pop(context);
      }
      else
        {
          print("get cashback from server");
         // _login();

        }
    });
  // });
  }
  getWallets(){
    // _showLoading();
    getData("USER_DATA").then((value) {
      if(value != null) {
        var data = jsonDecode(value);
        String uid = data['id'];
     setState(() {
          cashback = data['walletBalance'];
          print("wallet from server" +  cashback);

        });

      }
    });

  }
  _updateprofile() {
   // _showLoading();
    getData("USER_DATA").then((value) {
      if (value != null) {
        var data = jsonDecode(value);
        String uid = data['id'];
        loginForm.userid = uid;
        UserOtpVerify(loginForm).then((value) {
         // Navigator.pop(context);
          var response = jsonDecode(value!);
          if (response['status'] == 422) {
            setState(() {
              //inValid = true;
            });
          }
          else {
            var data = response['data'];
            String id = data['id'];
            print("response in otp");
            print(response);

            setData("USER", id).then((value) {
              setData("USER_DATA", jsonEncode(data)).then((value) {
                getWallets();
                //Navigator.pop(context,"TRUE");
                // _goHome();
                //Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                //Navigator.pop(launchproduct.\,"TRUE");
              });
            });
          }
        });
      }
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
                Icons.person,
                color: mainStyle.mainColor,
                size: 25,
              ),
              SizedBox(width: 5.0,),
              Text('Profile', style: TextStyle(color: Colors.amber,fontSize: 18),),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: FutureBuilder<String?>(
                          future: getData("USER_DATA"),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              var data = jsonDecode(snapshot.data!);
                              uid = data['id'];
                              user.id = data['id'];
                              user.name = data['name'];
                              user.email = data['email'];
                              user.mobile = data['mobile'];
                              user.city = data['city'];
                              user.state = data['state'];
                              user.pincode = data['pincode'];
                              user.address = data['address'];
                              user.wallet = data['walletBalance'];
                              // setState(() {
                                //cashback = user.wallet;
                              //});

                              return Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.person, size: 20.0,
                                          color: mainStyle.mainColor,),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text(user.name!, style: mainStyle.text16,)
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone_android, size: 20.0,
                                          color: mainStyle.mainColor,),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text('+91 ' + user.mobile!,
                                              style: mainStyle.text16,)
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.email, size: 20.0,
                                          color: mainStyle.mainColor,),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text(user.email!, style: mainStyle.text16,)
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 17,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Shipping Address', style: mainStyle.text18Bold,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(user.address!, style: mainStyle.text16,)
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(user.city! + ', ', style: mainStyle.text16,),
                                        Text(user.state !+ ' ', style: mainStyle.text16,),
                                        Text(user.pincode!, style: mainStyle.text16,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text('India', style: mainStyle.text16,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RaisedButton(
                                        onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context)=>EditProfile()
                                            )).then((value){
                                              if(value!=null){
                                                setState(() {

                                                });
                                              }
                                            });
                                        },
                                        color: Colors.grey[200],
                                        padding: EdgeInsets.all(12.0),
                                        child: (Text('Edit Profile',style: mainStyle.text16,)),
                                      ),
                                      RaisedButton(
                                        onPressed: (){
                                          _changePassword();
                                        },
                                        color: Colors.grey[200],
                                        padding: EdgeInsets.all(12.0),
                                        child: (Text('Change Password',style: mainStyle.text16,)),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                            return SpinKitThreeBounce(
                              color: Colors.amber,
                              size: 20,
                            );
                          },
                        ),
                      ),
                    ),
                  )

                ],
              ),
              Container(


                child: Card(
                  elevation: 2.0,


                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [

                          Text("Your Estore Wallet Balance",style: mainStyle.text14Bold,),
                        SizedBox(height: 10.0,),
                        Text(cashback,style: mainStyle.text14,)

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
