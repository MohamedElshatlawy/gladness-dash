import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/authentication.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddUser extends StatelessWidget {
  var userController = TextEditingController();
  var passController = TextEditingController();
  var confPassController = TextEditingController();
  var addUserKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addUserKey,
      backgroundColor: Colors.grey[250],
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('اضافة مستخدم'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/profile.png',
                  scale: 4,
                  color: MyColor.customColor,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: userController,
                  txtLablel: 'اسم مستخدم جديد',
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: passController,
                  txtLablel: 'كلمة المرور',
                  isPassword: true,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: confPassController,
                  isPassword: true,
                  txtLablel: 'تأكيد كلمة المرور',
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButton(
                  backgroundColor: Colors.grey[200],
                  textColor: MyColor.customColor,
                  txt: 'انشاء حساب',
                  btnPressed: () async {
                    if (validateInputs()) {

                      showMyDialog(
                        context: context,
                        msg: 'جاري تسجيل مستخدم جديد'
                      );

                      await registerUser(
                        userName: userController.text,
                        password: passController.text
                      ).then((value){
                        dismissDialog(context);
                        if(value==true){
                          showSnackbarError(
                            msg: 'تم تسجيل مستخدم جديد',
                            scaffoldKey: addUserKey
                          );
                          userController.clear();
                          passController.clear();
                          confPassController.clear();
                        }
                      }).catchError((e){
                        dismissDialog(context);
                           showSnackbarError(
                            msg: '$e',
                            scaffoldKey: addUserKey
                          );
                        print('ErrorUserReg:$e');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    if (userController.text.isEmpty ||
        passController.text.isEmpty ||
        confPassController.text.isEmpty) {
      showSnackbarError(
          msg: 'من فضلك قم بأدخال البيانات كاملة', scaffoldKey: addUserKey);
      return false;
    }else if(passController.text.length<6){
      showSnackbarError(msg: 'كلمة المرور ضعيفة جدا', scaffoldKey: addUserKey);
      return false;
   
    } else if (passController.text != confPassController.text) {
      showSnackbarError(msg: 'كلمة المرور غير متطابقة', scaffoldKey: addUserKey);
      return false;
    }
    return true;
  }
}
