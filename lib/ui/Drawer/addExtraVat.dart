import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/aboutUs.dart';
import 'package:qutub_dashboard/API/extraVat.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddExtraVat extends StatelessWidget {
   var myController = TextEditingController();

  var aboutKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: aboutKey,
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('تحديد ضريبة القيمة المضافة'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(20),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(MyCollections.extraVat)
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
                          snapSHot.data.docs[0].data()['vat'];
                    return Column(
                      children: <Widget>[
                        CustomTextField(
                          controller: myController,
                          txtLablel: 'قيمة الضريبة',
                          isNumber: true,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          backgroundColor: Colors.grey[200],
                          textColor: MyColor.customColor,
                          txt: 'تعديل',
                          btnPressed: () async {
                            if (myController.text.isEmpty) {
                              showSnackbarError(
                                  scaffoldKey: aboutKey, msg: 'حدد قيمة الضريبة');
                            } else {
                              showMyDialog(
                                  context: context, msg: 'جاري تحديث قيمة الضريبة');
                              await insertNewExtraVat(
                                      aboutTxt: myController.text)
                                  .then((value) {
                                dismissDialog(context);
                                showSnackbarError(
                                  msg: 'تم تحديث قيمة الضريبة بنجاح',
                                  scaffoldKey: aboutKey
                                );
                              }).catchError((e) {
                                dismissDialog(context);
                                print('EditExtraVatError:$e');
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