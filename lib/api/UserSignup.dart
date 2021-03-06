import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:estore/model/UserForm.dart';
import '../config.dart';

Future<String?> UserSignup(UserForm userForm) async {
  var body = {
    'name' : userForm.name,
    'email':userForm.email,
    'mobile':userForm.mobile,
    'password':userForm.password,
    'city':"",
    'state':"",
    'pincode':"",
    'address':"",
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'Athentication/signUp'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');
  request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    return reply;
  }

}