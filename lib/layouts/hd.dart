import 'dart:async';
import 'dart:convert';

import 'package:estore/api/getSetting.dart';
import 'package:estore/functions/UserData.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'BlockPage.dart';
import 'Cart.dart';
import 'CategoryList.dart';
import 'HomePage.dart';
import 'Login.dart';
import 'OrderHistory.dart';
import 'Profile.dart';
import 'dashBoard.dart';
import 'package:estore/style/textstyle.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String cCount = '0';
   late Timer timer;
  bool menuExpanded = false;
  bool login = false;
  bool checksubscription = true;
  int _pageIndex = 0;
  String uname = "";
  String uemail = "";

   late PageController _pageController;
  late VideoPlayerController _controller;
  int pos = 0;

  /* List<Widget> tabPages = [
    launchproduct(),
    CategoryList(),
    //launchproduct(),
    Cart(),
  ];*/
  List<Widget> tabPages = [
    dashBoard(),
    CategoryList(),
    //launchproduct(),
    Cart(),
  ];

  _getCount(){
    cartCount().then((value){
      String cc = '0';
      if(value>0) {
        cc = value.toString();
        if (value > 9) {
          cc = '9+';
        }
      }
      if(cc!=cCount){
        setState(() {
          cCount = cc;
        });
      }
    });
  }
  _logout(){
    removeData("USER").then((value){
      removeData("USER_DATA").then((value){
        removeData("SHIPPING_ADDRESS").then((value){
          setState(() {
            menuExpanded = false;
            login = false;
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addObserver(
    //     new LifecycleEventHandler(resumeCallBack: () async => _refreshContent()));

    //didChangeAppLifecycleState(state);
    _refreshContent();
    _pageController = PageController(initialPage: _pageIndex);
    checkData("USER").then((value){
      getData("USER_DATA").then((value) {
        String uid = "";
        if (value != null) {
          var data = jsonDecode(value);
          uid = data['id'];
          uname = data['name'];
          uemail = data['email'];

        }
      });
      if(value){
        setState(() {
          login = true;

        });
      }
    });
    _getCount();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _getCount());

  }
  void _refreshContent() {
    //setState(() {

    print('app refreshed');
    getSetting().then((value) {
      var response = jsonDecode(value!);
      if (response['status'] == 401) {
        setState(() {
          checksubscription = false;
          // _promocodeerrorDialog();
        });
      }

      // if (response['status'] == 200) {
      //   setState(() {
      //     checksubscription = true;
      //   });

      //     var data = response['data'];
      //     String shipapply = data['shipApply'];
      //   }
      // });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _pageController.dispose();
    super.dispose();
    timer?.cancel();
  }

  Widget loadpage()
  {

    if(checksubscription)
    {
      //return launchproduct();
      return dashBoard();

    }
    else
    {
      return BlockPage();
    }

  }
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: mainStyle.mainColor,

      //backgroundColor:Colors.pinkAccent,
      title: Row(
        children: [
          Text('E-Store',style: mainStyle.text20White,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 2.0),
              alignment: Alignment.centerRight,
              // child: GestureDetector(
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => Search()
              //     ));
              //
              //   },
              //   child: Icon(
              //     Icons.search,
              //     color: Colors.white,
              //     size: 25.0,
              //   ),
              // ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Cart()
              ));
            },
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 25,
                ),
                if(cCount!='0') Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(child: Text(cCount,style: TextStyle(color: Colors.white,fontSize: 10.0,fontFamily: 'Arial'),)))
              ],
            ),
          ),
          // login ? GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       menuExpanded = !menuExpanded;
          //     });
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(left: 5.0),
          //     child: Icon(
          //       menuExpanded ? Icons.close : Icons.more_vert,
          //       size: 25.0,
          //     ),
          //   ),
          // ) : GestureDetector(
          //   onTap: (){
          //     checkData("USER").then((value){
          //       if(value){
          //         setState(() {
          //           login = true;
          //           menuExpanded = !menuExpanded;
          //         });
          //       } else {
          //
          //         Navigator.push(context, MaterialPageRoute(
          //             builder: (context) => Login(false)
          //         ));
          //       }
          //     });
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(left: 10.0),
          //     child: Icon(
          //       Icons.person,
          //       size: 25.0,
          //     ),
          //   ),
          // )
        ],
      ),
    );
    AppBar BlockappBar = AppBar(
      backgroundColor: mainStyle.mainColor,
      title: Row(
        children: [
          Text('E-Store',style: mainStyle.text20White,),

        ],
      ),
    );
    return Scaffold(
        appBar: (checksubscription) ? appBar : BlockappBar,
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              InkWell(
                onTap: (){
                  checkData("USER").then((value){
                    if(value){
                      setState(() {
                        login = true;
                        //menuExpanded = !menuExpanded;
                      });
                    } else {
                      // Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) => Login(false)
                      // ));
                      _navigateAndDisplaySelection(context);

                    }
                  });
                  // if(!login) {
                  //   Navigator.pop(context);
                  //   Navigator.push(context, MaterialPageRoute(
                  //       builder: (context) => Login(false)
                  //   ));
                  //   //Navigator.pop(context);
                  // }

                },
                child: new UserAccountsDrawerHeader(
                  accountName: (login) ? Text(uname,style: TextStyle(color: Colors.black),) :
                  Text('Guest user',style: TextStyle(color: Colors.black),)  ,
                  accountEmail:  (login) ? Text(uemail,style: TextStyle(color: Colors.black),) :
                  Text('Login',style: TextStyle(color: Colors.black),),
                  currentAccountPicture: GestureDetector(
                    child: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black,),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.amberAccent
                  ),
                ),
              ),
              //body
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  },
                child: ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home,color: Colors.amber,),
                ),
              ),

              (login)
                  ?
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Profile()
                  ));
                },
                child: ListTile(
                  title: Text('My account'),
                  leading: Icon(Icons.person,color: Colors.purple,),
                ),
              )
                  : Container(),
              (login)
                  ?
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => OrderHistory()));
                },
                child: ListTile(
                  title: Text('My Orders'),
                  leading: Icon(Icons.shopping_basket,color: Colors.blue,),
                ),
              ) : Container(),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => HomePage('1'),
                  ));
                },
                child: ListTile(
                  title: Text('Categories'),
                  leading: Icon(Icons.dashboard,color: Colors.orange,),
                ),
              ),

              // InkWell(
              //   onTap: (){},
              //   child: ListTile(
              //     title: Text('Favourites'),
              //     leading: Icon(Icons.favorite,color: Colors.pink,),
              //   ),
              // ),

              Divider(),

              InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings, color: Colors.blue,),
                ),
              ),

              InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text('About'),
                  leading: Icon(Icons.help, color: Colors.green),
                ),
              ),
              Divider(),
              (login)
                  ?
              InkWell(
                onTap: (){
                  _logout();
                },
                child: ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
                ),
              ) : Container(),
            ],
          ),
        ),

        // bottomNavigationBar: BottomNavigationBar(
        //   items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Home"),backgroundColor: Colors.black),
        //     BottomNavigationBarItem(icon: Icon(Icons.list),title: Text("Category"),backgroundColor: Colors.black),
        //     //BottomNavigationBarItem(icon: Icon(Icons.star),title: Text("Launched"),backgroundColor: Colors.black),
        //     //BottomNavigationBarItem(icon: Icon(Icons.help),title: Text("Help"),backgroundColor: Colors.black),
        //     BottomNavigationBarItem(
        //       icon: new Stack(
        //         children: [
        //           Icon(
        //             Icons.shopping_cart,
        //
        //             size: 25,
        //           ),
        //           if(cCount!='0') Container(
        //               width: 15.0,
        //               height: 15.0,
        //               decoration: BoxDecoration(
        //                   color: Colors.amber[600],
        //                   borderRadius: BorderRadius.circular(15)
        //               ),
        //               child: Center(child: Text(cCount,style: TextStyle(color: Colors.white,fontSize: 10.0,fontFamily: 'Arial'),)))
        //         ],
        //
        //       ),
        //       title: Text('Orders'),
        //       backgroundColor: Colors.black
        //     )
        //   ],
        //
        //   currentIndex: _pageIndex,
        //   onTap: onTabTapped,
        //
        //
        //   // onTap: (int index) {
        //   //
        //   //   if(index == 2) {
        //   //     Navigator.push(context, MaterialPageRoute(
        //   //         builder: (context) => Cart()
        //   //     ));
        //   //   }
        //   //
        //   //   if(index == 1) {
        //   //     Navigator.push(context, MaterialPageRoute(
        //   //         builder: (context) => CategoryList()
        //   //     ));
        //   //   }
        //   //
        //   // },
        //
        //
        //
        // ) ,
        // body: PageView(
        //   children: tabPages,
        //   onPageChanged: onPageChanged,
        //   controller: _pageController,
        // ),
        body:

        GestureDetector(
            onTap: (){
              setState(() {
                if (menuExpanded)
                  menuExpanded = !menuExpanded;
                print("Tapped");
              });

            },
            // child: checksubscription ? launchproduct() : BlockPage()),
            child: checksubscription ? dashBoard() : BlockPage()),

        floatingActionButton: Visibility(

          visible: menuExpanded,
          child: Container(

            margin: EdgeInsets.fromLTRB(0,appBar.preferredSize.height+MediaQuery.of(context).padding.top+12, 0, 0),
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: mainStyle.mainColor,
                  child: Icon(Icons.person,size: 23.0,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Profile()
                    ));
                  },
                  heroTag: null,
                ),
                SizedBox(height: 5.0,),
                FloatingActionButton(
                  backgroundColor: mainStyle.mainColor,
                  child: Icon(Icons.list,size: 23.0,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => OrderHistory()
                    ));
                  },
                  heroTag: null,
                ),
                SizedBox(height: 5.0,),
                FloatingActionButton(
                  backgroundColor: mainStyle.mainColor,
                  child: Icon(Icons.exit_to_app,size: 23.0,color: mainStyle.secColor,),
                  onPressed: () {
                    _logout();
                  },
                  heroTag: null,
                )
              ],
            ),
          ),
        )
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login(false)),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

    String log = "$result";
    print("result is");
    print(log);
    if(log == "TRUE")
    {

      checkData("USER").then((value){
        getData("USER_DATA").then((value) {
          String uid = "";
          if (value != null) {
            var data = jsonDecode(value);
            uid = data['id'];
            uname = data['name'];
            uemail = data['email'];

          }
        });
        if(value){
          setState(() {
            login = true;

          });
        }
      });
    }
  }
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }

}