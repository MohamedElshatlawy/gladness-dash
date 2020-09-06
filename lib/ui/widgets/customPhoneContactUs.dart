import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/contactUs.dart';
import 'package:qutub_dashboard/models/contactUsModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class CustomPhoneContactUS extends StatelessWidget {
  ContactPhoneNumberModel phoneNumber;
  var ctx;
  CustomPhoneContactUS({this.phoneNumber, this.ctx});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.phone_android,
        color: MyColor.customColor,
        size: 20,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*Text(
            'تعديل',
            style: TextStyle(color: MyColor.customColor),
          ),
          SizedBox(
            width: 15,
          ),*/
          InkWell(
            onTap: () async {
              showMyDialog(context: ctx, msg: 'جاري حذف رقم التواصل');
              await removeContactPhone(phoneNumber).then((value) {
                dismissDialog(ctx);
              }).catchError((e) {
                dismissDialog(ctx);
                print('ErrorRemoveContactNumber:$e');
              });
            },
            child: Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      title: Text(
        phoneNumber.phone,
        style: TextStyle(color: MyColor.customColor, fontSize: 18),
      ),
    );
  }
}
