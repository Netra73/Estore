import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config.dart';

  Future<String?> getOrders(String uid) async {
  //http://ecom.digitalmarketinghubli.com/TEST_API/order/
  HttpClient httpClient = new HttpClient();

  HttpClientRequest request = await httpClient.getUrl(Uri.parse(  API_URL + 'userOrders/'+uid));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');
  HttpClientResponse response = await request.close();


  httpClient.close();
//  final response = await http.get(API_URL+'Products/getOrders/'+uid);
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    //String reply = response.body;
    return reply;
  }
}