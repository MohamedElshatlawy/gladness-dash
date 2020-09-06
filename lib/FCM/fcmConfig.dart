import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/models/NotificationModel.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

Future<dynamic> getFcmToken() async {
  
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token = await firebaseMessaging.getToken();

  User user =  FirebaseAuth.instance.currentUser;

  FirebaseFirestore.instance
      .collection(MyCollections.dashBoardUsers)
      .doc(user.uid)
      .update({'fcm_token': token});
}

Future<dynamic> saveNotification(
    NotificationModel model, String userID, String imgPath) async {
  await FirebaseFirestore.instance
      .collection(MyCollections.userCollection)
      .doc(userID)
      .collection(MyCollections.notification)
      .doc()
      .set({
    'title': model.title,
    'body': model.body,
    'imgPath': imgPath,
    'seen': false
  });
}

Future<dynamic> sendNotification(NotificationModel model, File img) async {
  String imgPath;
  if (img != null) {
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(MyCollections.images)
        .child(basename(img.path));

    await storageReference.putFile(img).onComplete.then((taskSnap) async {
      imgPath = await taskSnap.ref.getDownloadURL();
    });
  }
  await FirebaseFirestore.instance
      .collection(MyCollections.userCollection)
      .get()
      .then((value) async {
    Future.forEach(value.docs, (element) async {
      if (element.data['fcm_token'] != null) {
        await sendToAllClients(element.data['fcm_token'], model.title);
        await saveNotification(model, element.documentID, imgPath);
      }
    });
    value.docs.forEach((element) {});
  });
}

sendToAllClients(String userToken, String title) async {
  final String serverToken = MyCollections.serverToken;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  await post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': '', 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': userToken,
      },
    ),
  );
}

acceptOrderNotification(String userID) async {
  await FirebaseFirestore.instance
      .collection(MyCollections.userCollection)
      .doc(userID)
      .get()
      .then((value) async {
    sendToAllClients(value.data()['fcm_token'], 'تم قبول الطلب');
  });
}

rejectOrderNotification(String userID) async {
 FirebaseFirestore.instance
      .collection(MyCollections.userCollection)
      .doc(userID)
      .get()
      .then((value) async {
    await sendToAllClients(value.data()['fcm_token'], 'تم رفض الطلب ');
  });
}
