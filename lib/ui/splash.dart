import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/API/authentication.dart';
import 'package:qutub_dashboard/FCM/fcmConfig.dart';
import 'package:qutub_dashboard/Providers/userProvider.dart';
import 'package:qutub_dashboard/ui/Home/home.dart';
import 'package:qutub_dashboard/ui/Login/login.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    
    if (Platform.isIOS) {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //   _showItemDialog(message);
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //    _navigateToItemDetail(message);
      },
    );
    loadData();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    setState(() {
      loginStatus = true;
    });
    await checkUserLoggedIn().then((value) {
      if (value == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => Login()));
      } else {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(value);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => MainHome()));
      }
    }).catchError((e) {
      print(e);
      setState(() {
        loginStatus = false;
      });
      showSnackbarError(
          msg: 'حدث خطأ في الأتصال.حاول مرة اخرى', scaffoldKey: splashKey);
    });
  }

  var splashKey = GlobalKey<ScaffoldState>();
  var loginStatus;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: splashKey,
      backgroundColor: MyColor.customGreyColor,
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Image.asset(
          //   'assets/logo.png',
          //   scale: 8,
          // ),
          Text("Gladness",
          style: TextStyle(
            fontFamily: 'italy',
            fontSize: 60,
            
            color: MyColor.customColor
          ),
          ),
          SizedBox(
            height: 30,
          ),
          (loginStatus == true)
              ? CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(MyColor.whiteColor),
                )
              : (loginStatus == false)
                  ? Icon(
                      Icons.refresh,
                      color: MyColor.whiteColor,
                      size: 25,
                    )
                  : Container()
        ],
      )),
    );
  }
}
