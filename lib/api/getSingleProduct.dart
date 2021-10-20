import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config.dart';

Future<String?> getSingleProduct(String sizeId) async {
  //http://ecom.digitalmarketinghubli.com/TEST_API/productDetails/23
  HttpClient httpClient = new HttpClient();

  HttpClientRequest request = await httpClient.getUrl(Uri.parse( API_URL + 'productDetails/' +sizeId));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');

  // request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  // final response = await http.get(API_URL+'Products/getSingleProduct/'+sizeId);
  String desc = "";
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    var jdata = jsonDecode(reply);
    desc = jsonEncode(jdata['data']);
  }

  return desc;
}
