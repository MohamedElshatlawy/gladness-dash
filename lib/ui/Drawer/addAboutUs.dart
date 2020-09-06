import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/aboutUs.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddAboutUs extends StatelessWidget {
  var myController = TextEditingController();

  var aboutKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: aboutKey,
      backgroundColor: MyColor.customGreyColor,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColor.customColor,
            ),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: MyColor.whiteColor,
        title: Text('من نحن',style: TextStyle(
          color: MyColor.customColor
        ),),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(20),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(MyCollections.aboutUs)
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
                    if (snapSHot.data.docs.isNotEmpty)
                      myController.text =
                          snapSHot.data.docs[0].data()['aboutus'];
                    return Column(
                      children: <Widget>[
                        CustomTextField(
                          controller: myController,
                          txtLablel: 'اضف وصف',
                          lineCount: 8,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          backgroundColor: MyColor.customColor,
                          textColor: MyColor.whiteColor,
                          txt: 'تعديل',
                          btnPressed: () async {
                            if (myController.text.isEmpty) {
                              showSnackbarError(
                                  scaffoldKey: aboutKey, msg: 'قم بأدخل وصف');
                            } else {
                              showMyDialog(
                                  context: context, msg: 'جاري تحديث الوصف');
                              await insertNewAboutUs(
                                      aboutTxt: myController.text)
                                  .then((value) {
                                dismissDialog(context);
                                showSnackbarError(
                                  msg: 'تم تحديث الوصف بنجاح',
                                  scaffoldKey: aboutKey
                                );
                              }).catchError((e) {
                                dismissDialog(context);
                                print('EditAboutUsError:$e');
                              });
                            }
                          },
                        )
                      ],
                    );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
