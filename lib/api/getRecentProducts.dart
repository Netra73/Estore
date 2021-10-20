import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import '../model/Product.dart';
import '../config.dart';

Future<List<Product>> getRecentProducts() async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL + 'recent_products'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');

  HttpClientResponse response = await request.close();
  httpClient.close();
  List<Product> pList = [];
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    var jdata = jsonDecode(reply);
    var data = jdata['data'];
    for(var details in data){
      String id = details['pid'];
      String name = details['name'];
      String sizeId = details['sizeId'];
      String size = details['size'];
      String rate = details['rate'];
      String offer = details['offer'];
      String thumb = jsonEncode(details['thumb']);

      pList.add(Product(title: name,id: id,sizeId: sizeId,size: size,rate: rate,offer: offer,thumb: thumb,isPopular: false,isFavourite: false));
    }
  }

  return pList;
}
