
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../model/offerBanners.dart';

import '../config.dart';


Future<List<OfferBanners>> getOfferBanners() async {
  //http://ecom.digitalmarketinghubli.com/TEST_API/category
  //final response = await http.get(API_URL+'Products/category');
  HttpClient httpClient = new HttpClient();

  HttpClientRequest request = await httpClient.getUrl(Uri.parse( API_URL + 'slider'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');
  print("see reply for slider");
  HttpClientResponse response = await request.close();
  httpClient.close();
  List<OfferBanners> oList = [];
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    var jdata = jsonDecode(reply);
    var data = jdata['data'];
    for(var details in data){
      String id = details['id'];
      String title = details['title'];
      String image = details['image'];
      oList.add(OfferBanners(id,title,image));
    }
  }
  return oList;
}
