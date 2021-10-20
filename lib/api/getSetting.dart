import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config.dart';

Future<String?> getSetting() async {

  HttpClient httpClient = new HttpClient();

  //HttpClientRequest request = await httpClient.getUrl(Uri.parse('https://www.mipa.mu/estore/TEST_API/Athentication'));
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL +'Athentication'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');

  // request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }

}