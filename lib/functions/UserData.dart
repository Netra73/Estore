import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future setData (String key,String val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, val);
}
Future setcashbackamt (String key,String val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, val);
}
Future<String?> getData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? val = pref.getString(key);
  print(val);
  return val;
}

Future<bool> checkData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool status = pref.containsKey(key);
  print(status);
  return status;
}

Future removeData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(key);
}

Future setCart(key,val,clr) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);
  }
  //var color = [{'shadeColor': clr}];
  var cbody = {
    "qty":val,
    "clr":clr,

  };
  cartMap[key] = cbody;
  String cartString = jsonEncode(cartMap);

  pref.setString("cart", cartString);

}

Future<int> cartQnt(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();
  int qnt = 0;

  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);
  }
  if(cartMap.containsKey(key)) {

  var cbody= cartMap[key];
   qnt = int.parse(cbody['qty']);
   print(qnt);

  }
  return qnt;
}
Future<String> cartClr(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();
String clr = '';

  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);
  }
  if(cartMap.containsKey(key)) {
    var cbody= cartMap[key];
   // clr =cbody['clr'];
    clr  = cbody['clr'];
  }
  return clr;
}

Future<bool> checkCart(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);
    bool cstatus = cartMap.containsKey(key);

    return cstatus;
  }

  return status;

}

Future<int> cartCount() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();
  int cc = 0;
  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);

    cc = cartMap.length;
  }
  return cc;
}

Future removeCart(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String? cart = pref.getString("cart");
    cartMap = jsonDecode(cart!);
  }
  cartMap.remove(key);
  String cartString = jsonEncode(cartMap);
  pref.setString("cart", cartString);

}

Future clearCart() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  print("response");
  pref.remove("cart");
}

Future<String?> getCart() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? cart = pref.getString("cart");
  return cart;
}


















