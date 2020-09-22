import 'package:flutter/material.dart';
import 'package:qutub_dashboard/models/orderModel.dart';
import 'package:qutub_dashboard/models/reservation_model.dart';
import 'package:qutub_dashboard/ui/Home/Order/orderDetails.dart';

import '../../../common.dart';
import '../../colors.dart';
import '../../colors.dart';

class OrderListItem extends StatelessWidget {
  int index;
  ReservationModel orderModel;
  OrderListItem({this.index, this.orderModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => OrderDetails(
                      orderModel: orderModel,
                    )));
      },
      child: Container(
        color: MyColor.whiteColor,
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'طلب رقم # $index',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width / 4,
              color: (orderModel.status == "sent")
                  ? MyColor.customColor
                  : (orderModel.status == "cancel")
                      ? MyColor.custGrey2
                      : Color.fromRGBO(43, 188, 177, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (orderModel.status == "sent")
                        ? "تم الطلب"
                        : (orderModel.status == "cancel")
                            ? "تم الإلغاء"
                            : "تم التأكيد",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (orderModel.status == "cancel")
                            ? MyColor.customColor
                            : MyColor.whiteColor),
                  ),
                  Divider(
                    color: (orderModel.status == "cancel")
                        ? MyColor.customColor
                        : MyColor.whiteColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                  Text(
                    '${orderModel.totalPrice}',
                    style: TextStyle(
                        color: (orderModel.status == "cancel")
                            ? MyColor.customColor
                            : MyColor.whiteColor),
                  ),
                  Text(
                    'ريال',
                    style: TextStyle(
                        color: (orderModel.status == "cancel")
                            ? MyColor.customColor
                            : MyColor.whiteColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
