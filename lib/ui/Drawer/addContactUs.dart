import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/contactUs.dart';
import 'package:qutub_dashboard/models/contactUsModel.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customPhoneContactUs.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddContactUs extends StatelessWidget {
  var addContactKey = GlobalKey<ScaffoldState>();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addContactKey,
      backgroundColor: MyColor.customGreyColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColor.customColor,
            ),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: MyColor.whiteColor,
        title: Text(
          'أرقام التواصل',
          style: TextStyle(color: MyColor.customColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream:FirebaseFirestore.instance
                        .collection(MyCollections.contactUs)
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
                      if (snapSHot.hasError)
                        return new Text('خطأ: ${snapSHot.error}');
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
                                  child: Text('لا يوجد ارقام تواصل'),
                                )
                              : ListView.separated(
                                  itemBuilder: (ctx, index) {
                                    ContactPhoneNumberModel phoneModel =
                                        ContactPhoneNumberModel(
                                            id: snapSHot.data.docs[index]
                                                .id,
                                            phone: snapSHot
                                                .data
                                                .docs[index]
                                                .data()['phone']);
                                    return CustomPhoneContactUS(
                                      phoneNumber: phoneModel,
                                      ctx: context,
                                    );
                                  },
                                  itemCount: snapSHot.data.documents.length,
                                  separatorBuilder: (ctx, index) => SizedBox(
                                    height: 30,
                                  ),
                                );
                      }
                      return Container();
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                backgroundColor: MyColor.customColor,
                textColor: MyColor.whiteColor,
                txt: 'اضافة رقم تواصل جديد',
                btnPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'اضافة رقم تواصل جديد',
                                  textAlign: TextAlign.right,
                                ),
                                Divider()
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomTextField(
                                  isNumber: true,
                                  controller: phoneController,
                                  txtColor: MyColor.customColor,
                                  labelColor: MyColor.customColor,
                                  txtLablel: '',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                  backgroundColor: Colors.grey[200],
                                  textColor: MyColor.customColor,
                                  txt: 'تأكيد',
                                  btnPressed: () async {
                                    if (phoneController.text.isNotEmpty) {
                                      showMyDialog(
                                          context: ctx,
                                          msg: 'جاري تسجيل رقم تواصل جديد');
                                      await insertNewContactPhone(
                                              phone: phoneController.text)
                                          .then((value) {
                                        dismissDialog(ctx);
                                        dismissDialog(ctx);
                                        phoneController.clear();
                                      }).catchError((e) {
                                        dismissDialog(ctx);
                                        print('ErrorRegisterContactPhone:$e');
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
