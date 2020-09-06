import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/API/authentication.dart';
import 'package:qutub_dashboard/Providers/userProvider.dart';
import 'package:qutub_dashboard/ui/Drawer/addAboutUs.dart';
import 'package:qutub_dashboard/ui/Drawer/addCategory.dart';
import 'package:qutub_dashboard/ui/Drawer/addContactUs.dart';
import 'package:qutub_dashboard/ui/Drawer/addCoupon.dart';
import 'package:qutub_dashboard/ui/Drawer/addNotification.dart';
import 'package:qutub_dashboard/ui/Drawer/addUser.dart';
import 'package:qutub_dashboard/ui/Drawer/addVendor.dart';
import 'package:qutub_dashboard/ui/Drawer/viewMessages.dart';
import 'package:qutub_dashboard/ui/Login/login.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import 'addExtraVat.dart';
import 'addProduct.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: Container(
        color: MyColor.customGreyColor,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                // Image.asset(
                //       'assets/logo.png',
                //       scale: 10,
                //     ),
                Text(
                  "Gladness",
                  style: TextStyle(
                      fontFamily: 'italy',
                      fontSize: 50,
                      color: MyColor.customColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'لوحة التحكم',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColor.customColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  userProvider.userModel.email.toString(),
                  style: TextStyle(color: MyColor.customColor),
                ),
                SizedBox(
                  height: 30,
                ),
                  ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AddCategory()));
                  },
                  leading: Icon(
                    Icons.add,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'اضافة قسم جديد',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
              
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.customColor,
                ),
                   ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AddVendor()));
                  },
                  leading: Icon(
                    Icons.add,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'اضافة تاجر جديد',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
              
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.customColor,
                ),
                // ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (ctx) => AddProduct()));
                //   },
                //   leading: Icon(
                //     Icons.add,
                //     size: 20,
                //     color: MyColor.customColor,
                //   ),
                //   title: Text(
                //     'اضافة منتج جديد',
                //     style: TextStyle(color: MyColor.customColor),
                //   ),
                // ),
                // Divider(
                //   endIndent: 30,
                //   indent: 30,
                //   color: MyColor.customColor,
                // ),
                // ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (ctx) => AddCoupon()));
                //   },
                //   leading: Icon(
                //     Icons.local_offer,
                //     size: 20,
                //     color: MyColor.customColor,
                //   ),
                //   title: Text(
                //     ' اضافة كوبون خصم',
                //     style: TextStyle(color: MyColor.customColor),
                //   ),
                // ),
                // Divider(
                //   endIndent: 30,
                //   indent: 30,
                //   color: MyColor.customColor,
                // ),
                // ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (ctx) => AddUser()));
                //   },
                //   leading: Icon(
                //     Icons.supervised_user_circle,
                //     size: 20,
                //     color: MyColor.customColor,
                //   ),
                //   title: Text(
                //     'اضافة مستخدم',
                //     style: TextStyle(color: MyColor.customColor),
                //   ),
                // ),
                // Divider(
                //   endIndent: 30,
                //   indent: 30,
                //   color: MyColor.customColor,
                // ),

                // ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (ctx) => AddNotification()));
                //   },
                //   leading: Icon(
                //     Icons.notifications_active,
                //     size: 20,
                //     color: MyColor.customColor,
                //   ),
                //   title: Text(
                //     'ارسال اشعار',
                //     style: TextStyle(color: MyColor.customColor),
                //   ),
                // ),
                // Divider(
                //   endIndent: 30,
                //   indent: 30,
                //   color: MyColor.customColor,
                // ),

                // ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (ctx) => AddExtraVat()));
                //   },
                //   leading: Icon(
                //     Icons.description,
                //     size: 20,
                //     color: MyColor.customColor,
                //   ),
                //   title: Text(
                //     'تحديد ضريبة القيمة المضافة',
                //     style: TextStyle(color: MyColor.customColor),
                //   ),
                // ),
                // Divider(
                //   endIndent: 30,
                //   indent: 30,
                //   color: MyColor.customColor,
                // ),

                /*   ListTile(
                  onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddAboutUs()));
                
                  },
                  leading: Icon(
                    Icons.notifications_active,
                    size: 20,
                    color: MyColor.whiteColor,
                  ),
                   title: Text(
                    'اشعارات للعملاء',
                    style: TextStyle( color: MyColor.whiteColor),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.whiteColor,
                ),*/
                  ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => Messages()));
                  },
                  leading: Icon(
                    Icons.message,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'الرسائل',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.customColor,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AddAboutUs()));
                  },
                  leading: Icon(
                    Icons.description,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'من نحن',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.customColor,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctxt) => AddContactUs()));
                  },
                  leading: Icon(
                    Icons.phone_android,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'ارقام التواصل',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  color: MyColor.customColor,
                ),
                ListTile(
                  onTap: () async {
                    showMyDialog(context: context, msg: 'جاري تسجيل الخروج');
                    await logoutUser().then((value) {
                      dismissDialog(context);
                      if (value == true) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (ctx) => Login()));
                      }
                    }).catchError((e) {
                      dismissDialog(context);
                      print('ErrorLogout:$e');
                    });
                  },
                  leading: Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: MyColor.customColor,
                  ),
                  title: Text(
                    'تسجيل خروج',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
