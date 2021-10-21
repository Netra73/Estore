import 'dart:convert';
import 'dart:core';

import 'package:estore/api/getVideoRelatedProducts.dart';
import 'package:estore/layouts/ImageView.dart';
import 'package:estore/layouts/ProductDetails.dart';
import 'package:estore/model/Product.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class videoScreen extends StatefulWidget {
  final String mediaUrl, vid;

  const videoScreen({Key? key, required this.vid, required this.mediaUrl});

  @override
  _videoScreen createState() => _videoScreen(vid);
}

class _videoScreen extends State<videoScreen> {
  List<Product> vpList = [];

  bool _topbar = true;
  String vid;
  _videoScreen(this.vid);

  late ScrollController _scrollController;
  late FlickManager flickManager;
  // VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_topbar) {
          setState(() {
            _topbar = true;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_topbar) {
          setState(() {
            _topbar = false;
          });
        }
      }
    });
    // setState(() {
    //
    // });

    //_controller = VideoPlayerController.network(widget.mediaUrl)

    /*..addListener(() => setState(() {}))
      ..setLooping(true)
      ..setVolume(1.0)
      ..initialize().then((_) => _controller.play());
    _initializeVideoPlayerFuture = _controller.initialize();*/
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.mediaUrl),
    );
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(vpList.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainStyle.mainColor,
        title: Text(
          'EStore',
          style: mainStyle.text20White,
        ),
      ),
      body:
          /*Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: vpList.length == 0 ? FutureBuilder(
            future: getVideoRelatedProducts(vid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitDoubleBounce(
                  color: Colors.amber,
                  size: 20,
                );
              }
              if (snapshot.hasData) {
                vpList = snapshot.data;
                return videoRelatedProducts();
              }
              return Container(
                child: Text('No Products'),
              );
            },
          ) : videoRelatedProducts(),
        ),

      ),*/
          SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlickVideoPlayer(flickManager: flickManager),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
                child: Text(
                  "Relative Products",
                  style: mainStyle.text18,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: vpList.length == 0
                      ? FutureBuilder<List<Product>>(
                          future: getVideoRelatedProducts(vid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SpinKitDoubleBounce(
                                color: Colors.amber,
                                size: 20,
                              );
                            }
                            if (snapshot.hasData) {
                              vpList = snapshot.data!;
                              return videoRelatedProducts();
                            }
                            return Container(
                              child: Text('No Products'),
                            );
                          },
                        )
                      : videoRelatedProducts(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView videoRelatedProducts() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: vpList.length,
        itemBuilder: (context, i) {
          int offer = 0;
          String mrp = vpList[i].rate;
          if (vpList[i].offer != '0') {
            offer = int.parse(vpList[i].offer);
            double offRate = (offer / 100) * int.parse(mrp);
            double price = int.parse(mrp) - offRate;
            mrp = price.toStringAsFixed(0);
          }

          var thumb = jsonDecode(vpList[i].thumb);
          String thumbImg = thumb[0];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(vpList[i])));
            },
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ImageView(vpList[i].thumb)));
                                },
                                child: Hero(
                                  tag: vpList[i].thumb,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Image(
                                      image: NetworkImage(thumbImg),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        vpList[i].title,
                                        style: mainStyle.text16,
                                      ),
                                      Text(
                                        vpList[i].size,
                                        style: mainStyle.text12,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '\u20B9' + mrp + ' ',
                                                  style: mainStyle.text18Rate,
                                                ),
                                                if (offer > 0)
                                                  Text(
                                                    ' \u20B9' + vpList[i].rate,
                                                    style: TextStyle(
                                                        color:
                                                            mainStyle.textColor,
                                                        fontSize: 14,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                              ],
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                vpList[i])));
                                              },
                                              color: Colors.amber,
                                              child: Text(
                                                'BUY',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
