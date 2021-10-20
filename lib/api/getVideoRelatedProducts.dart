
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:estore/model/Product.dart';


import '../config.dart';


Future<List<Product>> getVideoRelatedProducts(String vid) async {
  //http://ecom.digitalmarketinghubli.com/TEST_API/category
  //final response = await http.get(API_URL+'Products/category');
  HttpClient httpClient = new HttpClient();

  //HttpClientRequest request = await httpClient.getUrl(Uri.parse( API_URL + 'video_products/'+vid));
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL  + 'video_products/' + vid));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');
  print("see reply for slider");
  HttpClientResponse response = await request.close();
  httpClient.close();
  List<Product> vpList = [];
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
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
      vpList.add(Product(title: name,id: id,sizeId: sizeId,size: size,rate: rate,offer: offer,thumb: thumb,isPopular: false,isFavourite: false));
      print(vpList.length);
    }
  }
  return vpList;
}

