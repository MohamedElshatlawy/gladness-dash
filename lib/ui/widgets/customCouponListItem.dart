import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/coupons.dart';
import 'package:qutub_dashboard/models/couponModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class CouponItem extends StatelessWidget {
  CouponModel couponModel;
  var ctx;
  var addCouponKey;
  CouponItem({this.couponModel,this.ctx,this.addCouponKey});
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(couponModel.coupon),
      trailing: Icon(Icons.keyboard_arrow_down),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('تفاصيل الكوبون',
            style: TextStyle(
              color: MyColor.customColor
            ),
            ),
          ],
        ),
        Divider(
          endIndent: 40,
          
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('قيمة الخصم',style: TextStyle(
              color: MyColor.customColor
            ),),
            Text('${couponModel.discountValue} ريال',style: TextStyle(
              color: Colors.red[800]
            ),)
          ],
        )
        ,SizedBox(
          height: 10,
        )
        ,Row(
          children: <Widget>[
            Flexible(child: Text(couponModel.description,
            style: TextStyle(
              color: Colors.grey
            ),
            )),
          ],
        )
        ,SizedBox(
          height: 10,
        ),
        CustomButton(
          backgroundColor: Colors.red[800],
          textColor: MyColor.whiteColor,
          txt: 'حذف الكوبون',
          btnPressed: () async {
             showMyDialog(context: ctx, msg: 'جاري حذف الكوبون');
              await removeCoupon(couponModel).then((value) {
                dismissDialog(ctx);
              }).catchError((e) {
                dismissDialog(ctx);
                /*
                 showSnackbarError(
                        msg: 'حدث خطأ في اضافة الكوبون حاول مرة اخرى',
                        scaffoldKey: addCouponKey
                      );*/
                print('ErrorRemoveCoupon:$e');
              });
          },
        )
      ],
    );
  }
}