import 'package:flutter/cupertino.dart';

class Product{
    final String id;
    final String sizeId;
    final String title;
    final String size;
    final String rate;
    final String offer;
    final String thumb;
    final bool isFavourite, isPopular;
    
    Product({
       required this.id, required this.sizeId,  required this.title, required this.size,  @required required this.rate,
        required this.offer,  required this.thumb,
        this.isFavourite = false,
        this.isPopular = false
});

}