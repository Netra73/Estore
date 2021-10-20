import 'package:estore/api/getOfferBanners.dart';
import 'package:estore/api/getSlider.dart';
import 'package:estore/api/getVideo.dart';
import 'package:estore/layouts/VideoScreen.dart';
import 'package:estore/model/SliderImage.dart';
import 'package:estore/model/VideoLink.dart';
import 'package:estore/model/offerBanners.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:core';

import 'package:http/http.dart' as http;



class OffersPage extends StatefulWidget {
  @override
  _OffersPage createState() => _OffersPage();
}

class _OffersPage extends State<OffersPage> {
  List<OfferBanners>oList = [];


  @override
  Widget build(BuildContext context) {

    print(oList.length);

    return /*Container(
      padding: EdgeInsets.all(10.0),
      child: sList.length == 0 ? FutureBuilder(
        future: getSliderImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitThreeBounce(
              color: Colors.amber,
              size: 20,
            );
          }
          if (snapshot.hasData) {
            sList = snapshot.data;
            print(snapshot.data);
            return offerList();
          }
          return Container(
            child: Text('No slides'),
          );
        },
      ) : offerList(),

    );*/
      Container(
        padding: EdgeInsets.all(10.0),
        child: oList.length == 0 ? FutureBuilder<List<OfferBanners>>(
          future: getOfferBanners(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitThreeBounce(
                color: Colors.amber,
                size: 20,
              );
            }
            if (snapshot.hasData) {
              oList = snapshot.data!;
              return offerList();
            }
            return Container(
              child: Text('No videos'),
            );
          },
        ) : offerList(),

      );
  }

  /*ListView offerList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: sList.length,
        itemBuilder: (cc, i) {
          return Card(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
            color: Colors.red,
            child: Container(
              height: 150,
             width: 100,
              child: Column(
                children: [
                Image.network(sList[i].image)
                 /* Image(
                    image: AssetImage(oList[i].),
                    width: 100,
                    fit
                        : BoxFit.cover,
                  ),*/
                ],
              ),
            ),
          );
        });
  }*/
  ListView offerList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: oList.length,
        itemBuilder: (cc, i) {
          return Card(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 2.0),
              child: Container(
                child: Stack(
                  children: [
                    FutureBuilder(
                        future: getVideoList(),
                        builder: (cc, snap) {
                          print(snap.data.toString());
                          if (snap.hasData) {
                            return Container(
                                height: 200,
                                width: 300,
                                child: Image.network(oList[i].image)
                            );
                          }
                          return SizedBox();
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

}