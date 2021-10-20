
import 'dart:io';

import 'package:estore/api/getVideo.dart';
import 'package:estore/layouts/VideoScreen.dart';
import 'package:estore/model/VideoLink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:estore/style/textstyle.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:core';

import 'package:video_thumbnail/video_thumbnail.dart';


/*var videoList=[

  {
    'name':'Big Buck Buny',
    'media_url':'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'thumb_url':'https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg',
  },
  {
    'name':'Elephant Dream',
    'media_url':'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'thumb_url':'https://i.ytimg.com/vi/eFQxRd0isAQ/maxresdefault.jpg',
  },
  {
    'name':'For Bigger Blazes',
    'media_url':'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'thumb_url':'https://d2z1w4aiblvrwu.cloudfront.net/ad/76Ab/google-chromecast-bigger-blazes-large-7.jpg',
  },

];*/


class  VideosPage extends StatefulWidget {
  @override
  _VideosPage createState() => _VideosPage();
}

class _VideosPage extends State<VideosPage> {
  List<VideoLink>vList = [];
  var formatted;
 // var mediaUrl = 'https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg';

  /*Future<File> getThumb(vpath) async{
   print("Vpath "+vpath);
    final fileName = await VideoThumbnail.thumbnailFile(
      video: "https://www.mipa.mu/estore/assets/upload/video/kkkk.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
       maxWidth: 100,
      timeMs:2,
    quality: 75,
    );
    print("Thumb "+fileName);
    File tmpFile = File(fileName);
    return tmpFile;

  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getThumb().then((value){
    //   print("thumb "+value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    print(vList.length);
    return Container(
      padding: EdgeInsets.all(10.0),
      child: vList.length == 0 ? FutureBuilder<List<VideoLink>>(
        future: getVideoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitThreeBounce(
              color: Colors.amber,
              size: 20,
            );
          }
          if (snapshot.hasData) {
            vList = snapshot.data!;
            return videoList();
          }
          return Container(
            child: Text('No videos'),
          );
        },
      ) : videoList(),

    );
  }

  ListView videoList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: vList.length,
        itemBuilder: (cc, i) {
          String date = vList[i].date;
           return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 15,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                   builder: (context) => videoScreen(mediaUrl: vList[i].path,vid: vList[i].vid,),

                  ));
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon(Icons.play_circle_fill),
                      Stack(
                        children: [
                        FutureBuilder(
                              future:getVideoList(),
                              builder: (cc,snap){
                                print(snap.data.toString());
                                if(snap.hasData){
                                  return Container(
                                    height: 100,
                                      width: 100,
                                      child: Image.network(vList[i].videoPoster)
                                  );
                                }
                                return SizedBox();
                              }),

                          SizedBox(width: 5.0),
                          Container(
                              width: 100,
                              height: 100,
                              child: Center(child: Icon(
                                Icons.play_circle_outline, size: 50.0,))),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Text(vList[i].title, style: mainStyle.text20Bold,),
                              SizedBox(height: 10,),
                              Text(vList[i].date, style: mainStyle.text14,),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}