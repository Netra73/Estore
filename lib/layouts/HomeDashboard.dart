import 'dart:convert';

import 'package:estore/functions/UserData.dart';
import 'package:estore/layouts/LoyalityPage.dart';
import 'package:estore/layouts/OffersPage.dart';
import 'package:estore/layouts/VideosPage.dart';
import 'package:estore/main.dart';
import 'package:estore/model/Category.dart';
import 'package:estore/style/textstyle.dart';
import 'package:flutter/material.dart';

import 'Cart.dart';
import 'HomePage.dart';
import 'Login.dart';
import 'OrderHistory.dart';
import 'Profile.dart';
import 'launchproduct.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> with RouteAware {
  int _selectedIndex = 0;
  String catId = "1";

  int cCount = 0;
  bool menuExpanded = false;
  bool login = false;
  bool checksubscription = true;
  String uname = "";
  String uemail = "";

  late List<Category> category;
  @override
  void initState() {
    _refreshCartCount();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  void _refreshCartCount() {
    //TODO Call cart products count and set it to cCount
  }

  @override
  void didPopNext() {
    _refreshCartCount();
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  _logout() {
    removeData("USER").then((value) {
      removeData("USER_DATA").then((value) {
        removeData("SHIPPING_ADDRESS").then((value) {
          setState(() {
            menuExpanded = false;
            login = false;
          });
        });
      });
    });
  }

  setBottomBarIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _callBack(String cid) {
    setState(() {
      catId = cid;
      _selectedIndex = 2;
    });
  }

  final tabs = [
    Center(child: Text("Home", style: TextStyle(color: Colors.white))),
    Center(child: Text("cart", style: TextStyle(color: Colors.white))),
    Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
    Center(child: Text("Folder", style: TextStyle(color: Colors.white))),
    Center(child: Text("Add Items", style: TextStyle(color: Colors.white))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //header
            InkWell(
              onTap: () {
                checkData("USER").then((value) {
                  if (value) {
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
                accountName: (login)
                    ? Text(
                        uname,
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'Guest user',
                        style: TextStyle(color: Colors.black),
                      ),
                accountEmail: (login)
                    ? Text(
                        uemail,
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'Login',
                        style: TextStyle(color: Colors.black),
                      ),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
                decoration: new BoxDecoration(color: Colors.amberAccent),
              ),
            ),

            //body

            InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Home'),
                leading: Icon(
                  Icons.home,
                  color: Colors.amber,
                ),
              ),
            ),

            (login)
                ? InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: ListTile(
                      title: Text('My account'),
                      leading: Icon(
                        Icons.person,
                        color: Colors.purple,
                      ),
                    ),
                  )
                : Container(),
            (login)
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderHistory()));
                    },
                    child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : Container(),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  catId = '1';
                });
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Categories'),
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.orange,
                ),
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
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help, color: Colors.green),
              ),
            ),
            Divider(),
            (login)
                ? InkWell(
                    onTap: () {
                      _logout();
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: mainStyle.mainColor,
        title: Row(
          children: [
            Text(
              'E-Store',
              style: mainStyle.text20White,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 2.0),
                alignment: Alignment.centerRight,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 25,
                  ),
                  Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                          color: Colors.amber[600],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                        '$cCount',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontFamily: 'Arial'),
                      )))
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: _selectedIndex == 0
            ? launchproduct(_callBack)
            : _selectedIndex == 1
                ? OffersPage()
                : _selectedIndex == 2
                    ? HomePage(catId)
                    : _selectedIndex == 3
                        ? LoyalityPage()
                        : _selectedIndex == 4
                            ? VideosPage()
                            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainStyle.mainColor,
        onPressed: () {
          setBottomBarIndex(2);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: mainStyle.mainColor,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                ),
                onPressed: () {
                  setBottomBarIndex(0);
                },
                splashColor: Colors.white,
              ),
              IconButton(
                  icon: Icon(
                    Icons.local_offer_rounded,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  onPressed: () {
                    setBottomBarIndex(1);
                  }),
              SizedBox.shrink(),
              IconButton(
                  icon: Icon(
                    Icons.explore,
                    color: _selectedIndex == 3 ? Colors.white : Colors.grey,
                  ),
                  onPressed: () {
                    setBottomBarIndex(3);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.video_call_outlined,
                    color: _selectedIndex == 4 ? Colors.white : Colors.grey,
                  ),
                  onPressed: () {
                    setBottomBarIndex(4);
                  }),
            ],
          ),
        ),
      ),

      /*  bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home',style: TextStyle(color: Colors.white),),
                  backgroundColor:mainStyle.mainColor,
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer_outlined),
                  title: Text('Offers',style: TextStyle(color: Colors.white),),
                  backgroundColor: mainStyle.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded,),
                title: Text('Explore',style: TextStyle(color: Colors.white),),
                backgroundColor: mainStyle.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.loyalty_rounded),
                title: Text('Loyality',style: TextStyle(color: Colors.white),),
                backgroundColor:mainStyle.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_call_sharp,),
                title: Text('Videos',style: TextStyle(color: Colors.white),),
                backgroundColor:mainStyle.mainColor,
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            iconSize: 35,
            onTap: (i){
              setState(() {
                catId = "1";
                _selectedIndex=i;
              });
            },
            elevation: 5
        )*/
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
    if (log == "TRUE") {
      checkData("USER").then((value) {
        getData("USER_DATA").then((value) {
          print(getData("USER_DATA"));
          String uid = "";
          if (value != null) {
            var data = jsonDecode(value);
            uid = data['id'];
            uname = data['name'];
            uemail = data['email'];
          }
        });
        if (value) {
          setState(() {
            login = true;
          });
        }
      });
    }
  }
}
