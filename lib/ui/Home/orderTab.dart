import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/Providers/userProvider.dart';
import 'package:qutub_dashboard/models/orderModel.dart';
import 'package:qutub_dashboard/models/reservation_model.dart';

import '../colors.dart';
import 'Order/orderListItem.dart';

class OrderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:FirebaseFirestore.instance
          .collection("reservations")
         
          .orderBy('time_stamp',
          descending: true
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
        if (snapSHot.hasError) {
          print(snapSHot.error);
          return new Text('خطأ: ${snapSHot.error}');
        }
        switch (snapSHot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.none:
            return Center(
              child: Text('لايوجد اتصال بالأنترنت'),
            );
          case ConnectionState.active:

          case ConnectionState.done:
            return (snapSHot.data.docs.isEmpty)
                ? Center(
                    child: Text('لا يوجد حجوزات'),
                  )
                : ListView.separated(
                  
                  separatorBuilder: (ctx,index)=>SizedBox(height: 10,),
                    itemCount: snapSHot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      ReservationModel model=ReservationModel.fromJson(
                        id: snapSHot.data.docs[index].id,
                        json:  snapSHot.data.docs[index].data()
                      );
                      
                      return OrderListItem(
                        index: snapSHot.data.docs.length-index,
                        orderModel: model,
                      );
                    },
                  );
        }
        return Container();
      },
    );
 
 
  }
}
