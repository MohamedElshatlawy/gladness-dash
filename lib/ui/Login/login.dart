import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/API/authentication.dart';
import 'package:qutub_dashboard/Providers/userProvider.dart';
import 'package:qutub_dashboard/models/userModel.dart';
import 'package:qutub_dashboard/ui/Home/home.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class Login extends StatelessWidget {
  var loginKey = GlobalKey<ScaffoldState>();
  var mailController = TextEditingController();
  var passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: loginKey,
      backgroundColor: MyColor.customGreyColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Text("Gladness",
          style: TextStyle(
            fontFamily: 'italy',
            fontSize: 50,
            
            color: MyColor.customColor
          ),
          ),
                  // Image.asset(
                  //   'assets/logo.png',
                  //   scale: 8,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'لوحة التحكم',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: MyColor.customColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    controller: mailController,
                    isMail: true,
                    txtLablel: 'اسم المستخدم',
                    txtColor: MyColor.customColor,
                    labelColor: MyColor.customColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: passController,
                    isPassword: true,
                    txtColor: MyColor.customColor,
                    labelColor: MyColor.customColor,
                    txtLablel: 'كلمة المرور',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    txt: 'تسجيل دخول',
                    textColor: MyColor.whiteColor,
                    backgroundColor: MyColor.customColor,
                    btnPressed: () async {
                      //validateInputs
                      if (validateInputs()) {
                        showMyDialog(
                            context: context, msg: 'جاري تسجيل الدخول');

                        //loginUser
                        await loginUser(
                                userName: mailController.text,
                                password: passController.text)
                            .then((value) {
                          dismissDialog(context);
                          if (value is UserModel) {
                            var userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            userProvider.setUser(value);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MainHome()));
                          }
                        }).catchError((e) {
                         
                          dismissDialog(context);
                          showSnackbarError(msg: '$e', scaffoldKey: loginKey);
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    if (mailController.text.isEmpty || passController.text.isEmpty) {
      showSnackbarError(
          msg: 'من فضلك قم بأدخال البيانات كاملة', scaffoldKey: loginKey);
      return false;
    }
    return true;
  }
}
