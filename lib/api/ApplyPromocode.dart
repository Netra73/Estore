import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config.dart';

Future<String?> Applypromocode(String userid,String pcode) async {
  var body =
  {
    'user': userid,
    'code': pcode,

  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'Athentication/verifyPromoCode'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');
  request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }

}