import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/coupons.dart';
import 'package:qutub_dashboard/models/couponModel.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customCouponListItem.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddCoupon extends StatelessWidget {
  var couponController = TextEditingController();
  var discountController = TextEditingController();
  var discripCOntroller = TextEditingController();
  var addCouponKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addCouponKey,
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('اضافة كوبون خصم'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              CustomTextField(
                txtLablel: 'اضف كوبون',
                controller: couponController,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                txtLablel: 'قيمة الخصم بالريال',
                isNumber: true,
                controller: discountController,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                txtLablel: 'وصف الكوبون',
                lineCount: 2,
                controller: discripCOntroller,
              ),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                backgroundColor: Colors.grey[200],
                textColor: MyColor.customColor,
                txt: 'اضافة كوبون جديد',
                btnPressed: () async {
                  if (validateInputs()) {
                    showMyDialog(
                      context: context,
                      msg: 'جاري اضافة كوبون جديد'
                    );
                    await insertNewCoupon(
                      couponModel: CouponModel(
                        coupon: couponController.text,
                        description: discripCOntroller.text,
                        discountValue: discountController.text
                      )
                    ).then((value) {
                      dismissDialog(context);
                      couponController.clear();
                      discountController.clear();
                      discripCOntroller.clear();
                      showSnackbarError(
                        msg: 'تم اضافة الكوبون بنجاح',
                        scaffoldKey: addCouponKey
                      );
                    }).catchError((e){
                      dismissDialog(context);
                      /*showSnackbarError(
                        msg: 'حدث خطأ في اضافة الكوبون حاول مرة اخرى',
                        scaffoldKey: addCouponKey
                      );*/
                      print('ErrorInsertCoupon:$e');
                    });
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(MyCollections.coupon)
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
                                  child: Text('لا يوجد كوبونات خصم'),
                                )
                              : ListView.separated(
                                  itemBuilder: (ctx, index) {
                                    CouponModel model = CouponModel(
                                      id: snapSHot
                                          .data.docs[index].id,
                                      coupon: snapSHot
                                          .data.docs[index].data()['coupon'],
                                      description: snapSHot.data
                                          .docs[index].data()['description'],
                                      discountValue: snapSHot
                                          .data
                                          .docs[index]
                                          .data()['discountValue'],
                                    );
                                    return CouponItem(
                                      couponModel: model,
                                      addCouponKey: addCouponKey,
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
            ],
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    if (couponController.text.isEmpty ||
        discripCOntroller.text.isEmpty ||
        discountController.text.isEmpty) {
      showSnackbarError(
          msg: 'قم بأدخال بيانات الكوبون المطلوبة', scaffoldKey: addCouponKey);
      return false;
    }

    return true;
  }
}
