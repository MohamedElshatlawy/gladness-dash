import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qutub_dashboard/FCM/fcmConfig.dart';
import 'package:qutub_dashboard/models/NotificationModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class AddNotification extends StatefulWidget {
  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  var titleController=TextEditingController();

  var bodyController=TextEditingController();

  File img;
var notKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: notKey,
        appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('ارسال اشعار جديد'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: MyColor.customColor)),
                              child: ClipOval(
                                  child: (img != null)
                                      ? Image.file(img,
                                      fit: BoxFit.cover,
                                      )
                                      : (img == null)
                                          ? Image.asset(
                                              'assets/camera.png',
                                              color: MyColor.customColor,
                                              scale: 4,
                                            )
                                          : Image.file(
                                              img,
                                              fit: BoxFit.cover,
                                              )))),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              img = await getImage();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.red[800],
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                CustomTextField(
                  controller: titleController,
                  labelColor: MyColor.customColor,
                  txtColor: MyColor.customColor,
                  txtLablel: 'عنوان الأشعار',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: bodyController,
                  labelColor: MyColor.customColor,
                  txtColor: MyColor.customColor,
                  txtLablel: 'محتوى الأشعار',
                  lineCount: 2,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButton(
                  backgroundColor: MyColor.whiteColor,
                  textColor: MyColor.customColor,
                  txt: 'ارسال',
                  btnPressed: () async {
                    if (titleController.text.isEmpty) {
                      showSnackbarError(
                          msg: 'من فضلك ادخل عنوان الأشعار',
                          scaffoldKey: notKey);
                      return;
                    }else if (bodyController.text.isEmpty) {
                      showSnackbarError(
                          msg: 'من فضلك ادخل محتوى الأشعار',
                          scaffoldKey: notKey);
                      return;
                    }
                  
                    showMyDialog(context: context, msg: 'جاري ارسال الأشعار');
                    await sendNotification(NotificationModel(
                      body: bodyController.text,
                      title: titleController.text
                    ),
                    img
                    ).then((value) {
                      dismissDialog(context);
                     
                      setState(() {
                        bodyController.clear();
                        titleController.clear();
                      });
                    }).catchError((e) {
                      dismissDialog(context);
                      print('ErrorSendNotification:$e');
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
   
    );
  }
}