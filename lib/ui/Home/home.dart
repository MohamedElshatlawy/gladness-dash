import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/FCM/fcmConfig.dart';

import 'package:qutub_dashboard/Providers/bottomNavProvider.dart';
import 'package:qutub_dashboard/common.dart';
import 'package:qutub_dashboard/ui/Drawer/myDrawer.dart';
import 'package:qutub_dashboard/ui/Home/homeTab.dart';
import 'package:qutub_dashboard/ui/Home/orderTab.dart';
import 'package:qutub_dashboard/ui/colors.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getFcmToken();
  }
  var mainHomeKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      key: mainHomeKey,
      backgroundColor: MyColor.customGreyColor,
        appBar: AppBar(
          backgroundColor:MyColor.whiteColor,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.menu,color: MyColor.customColor,), onPressed: (){
              mainHomeKey.currentState.openEndDrawer();
            })
          ],
          title: Text(bottomNavProvider.getTabName(),
          style: TextStyle(
            color: MyColor.customColor
          ),
          ),
          centerTitle: true,
        ),
        endDrawer: MyDrawer(),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedLabelStyle: TextStyle(fontSize: 16),
            currentIndex: bottomNavProvider.selectedIndex,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              bottomNavProvider.onTapClick(index);
            },
            selectedItemColor: MyColor.customColor,
            items: [
              BottomNavigationBarItem(
                backgroundColor: MyColor.whiteColor,
                  icon: Container(
                    width: 30,
                    height: 22,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance
                          .collection("reservations")
                          .snapshots(),
                      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
                        if (snapSHot.hasError) return Container();
                        switch (snapSHot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.active:

                          case ConnectionState.done:
                            int count = 0;
                            snapSHot.data.docs.forEach((element) {
                              if (element.data()['orderStatus'] ==
                                  Common.reviewStatus) {
                                count++;
                              }
                            });
                            return (snapSHot.data.documents.isEmpty ||
                                    count == 0)
                                ? Container(
                                  child: Center(
                                        child: Icon(Icons.receipt),
                                      ),
                                )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Center(
                                        child: Icon(Icons.receipt),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$count',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                        }
                        return Container();
                      },
                    ),
                  ),
                  title: Text('الحجوزات')),
              BottomNavigationBarItem(

                backgroundColor: MyColor.whiteColor,
                  icon: Icon(Icons.home),
                  title: Text(
                    'الأقسام',
                  )),
            ]),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
              margin: EdgeInsets.all(10),
              child: bottomNavProvider.selectedIndex == 1
                  ? HomeTab()
                  : OrderTab()),
        ));
  }
}
