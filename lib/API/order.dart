import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_dashboard/FCM/fcmConfig.dart';
import 'package:qutub_dashboard/common.dart';
import 'package:qutub_dashboard/models/productModel.dart';

import 'CommonCollections.dart';

Future<dynamic> getProductDetails(String productID) async {
  ProductModel productModel;
  await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc(productID)
      .get()
      .then((value) {
    productModel = ProductModel.fromJson(id: value.id, json: value.data());
  });

  return productModel;
}

Future<dynamic> confirmReservation({String orderID, String uID}) async {
  await FirebaseFirestore.instance
      .collection("reservations")
      .doc(orderID)
      .update({
    'status': 'confirm',
    'time_stamp': DateTime.now().millisecondsSinceEpoch
  });

  acceptOrderNotification(uID);
}

Future<dynamic> rejectReservation({String orderID, String uID}) async {
  await FirebaseFirestore.instance
      .collection("reservations")
      .doc(orderID)
      .update({'status': "cancel"});
  rejectOrderNotification(uID);
}

Future<dynamic> confirmOrder(
    String orderID, String deliveryCost, String uID) async {
  await FirebaseFirestore.instance
      .collection(MyCollections.orders)
      .doc(orderID)
      .update({
    'orderStatus': Common.confirmedStatus,
    'deliveryCost': deliveryCost
  });
  acceptOrderNotification(uID);
}

Future<dynamic> rejectOrder(
    String orderID, String rejectMsg, String uID) async {
  await FirebaseFirestore.instance
      .collection(MyCollections.orders)
      .doc(orderID)
      .update(
          {'orderStatus': Common.rejectedStatus, 'reasonOfReject': rejectMsg});
  rejectOrderNotification(uID);
}
