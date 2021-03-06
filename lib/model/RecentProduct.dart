import 'package:flutter/cupertino.dart';

class RecentProduct {
  final String id;
  final String sizeId;
  final String title;
  final String size;
  final String rate;
  final String offer;
  final String thumb;
  final bool isFavourite, isPopular;

  RecentProduct(
      {required this.id,
      required this.sizeId,
      required this.title,
      required this.size,
      required this.rate,
      required this.offer,
      required this.thumb,
      this.isFavourite = false,
      this.isPopular = false});
}
