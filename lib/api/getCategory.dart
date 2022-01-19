import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../model/Category.dart';
import '../config.dart';

Future<List<Category>> getCategory() async {
  //http://ecom.digitalmarketinghubli.com/TEST_API/category
  //final response = await http.get(API_URL+'Products/category');
  HttpClient httpClient = new HttpClient();

  HttpClientRequest request = await httpClient.getUrl(Uri.parse( API_URL + 'category'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization','e10adc3949ba59abbe56e057f20f883e');

  // request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  List<Category> cList = [];
  if(response.statusCode == 200){
    String reply = await response.transform(utf8.decoder).join();
    var jdata = jsonDecode(reply);
    var data = jdata['data'];
    for(var details in data){
      String id = details['id'];
      String title = details['title'];
      String icon = details['icon'];
      cList.add(Category(id,title,icon));
      print(cList);
      print(cList);
    }
  }
  return cList;

}