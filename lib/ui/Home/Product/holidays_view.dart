import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/vendors.dart';
import 'package:qutub_dashboard/models/vendorModel.dart';
import 'package:qutub_dashboard/ui/Drawer/NonRegularHolidayDialog.dart';
import 'package:qutub_dashboard/ui/Drawer/regularHolidaysDialog.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../../colors.dart';

class HolidaysView extends StatefulWidget {
  VendorModel model;

  Map<String, dynamic> dateTime = {};
  Map<String, bool> days = {
    'الجمعة': false,
    'السبت': false,
    'الأحد': false,
    'الأثنين': false,
    'الثلاثاء': false,
    'الأربعاء': false,
    'الخميس': false,
  };
  HolidaysView(this.model) {
    dateTime.addAll(model.nonRegulars);
    days.forEach((key, value) {
      if (model.regularHolidays.contains(key)) {
        days[key] = true;
      }
    });
  }

  @override
  _HolidaysViewState createState() => _HolidaysViewState();
}

class _HolidaysViewState extends State<HolidaysView> {
  var holidayKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: holidayKey,
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            onTap: () async {
              widget.model.regularHolidays.clear();
              widget.model.regularHolidays.addAll(resetSelectedDays());

              widget.model.nonRegulars.clear();
              widget.model.nonRegulars.addAll(widget.dateTime);

              showMyDialog(
                context: context,
                msg: 'جاري تعديل الأجازات'
              );
             await updateVendorsHolidays(widget.model).catchError((e){
               dismissDialog(context);
               print('ErrorUpdateVendorHolidays:$e');
             }).then((value){
               dismissDialog(context);
               showSnackbarError(
                 msg: 'تم تعديل الأجازات بنجاح',
                 scaffoldKey: holidayKey
               );
             });
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: MyColor.customColor,
                  size: 25,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'تعديل',
                  style: TextStyle(color: MyColor.customColor, fontSize: 18),
                )
              ],
            ),
          )
        ],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColor.customColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: MyColor.whiteColor,
        title: Text(
          "مواعيد الأجازة",
          style: TextStyle(color: MyColor.customColor),
        ),
        centerTitle: true,
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'مواعيد الأجازة المنتظمة',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: MainHolidaysDialog(
                                          widget.days, this, false)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (ctx, index) => SizedBox(
                              width: 10,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) => RaisedButton(
                              elevation: 0,
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {},
                              child: Text(resetSelectedDays()[index]),
                            ),
                            itemCount: resetSelectedDays().length,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'مواعيد الأجازة الغير المنتظمة',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: NonRegularHolidayDialog(
                                          widget.dateTime, this)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ////////////////////
                        ///
                      ],
                    ),
                  ),
                  ...getUnRegularHolidays(),
                ],
              ),
            ),
          )),
    );
  }

  List resetSelectedDays() {
    List<String> selectedDays = [];

    widget.days.forEach((key, value) {
      if (value == true) {
        selectedDays.add(key);
      }
    });
    return selectedDays;
  }

  List<Widget> getUnRegularHolidays() {
    List<Widget> data = [];
    widget.dateTime.forEach((key, value) {
      data.add(
        ExpansionTile(
          title: Text(key),
          children: <Widget>[
            Container(
              height: 47,
              child: RaisedButton(
                  textColor: Colors.white,
                  onPressed: () {},
                  color: MyColor.customColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('الفترة من : '),
                          SizedBox(
                            width: 10,
                          ),
                          Text(value['from'])
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('الفترة إلى : '),
                          SizedBox(
                            width: 10,
                          ),
                          Text(value['to'])
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
                height: 47,
                child: RaisedButton(
                  textColor: Colors.white,
                  onPressed: () {
                    widget.dateTime.remove(key);

                    setState(() {});
                  },
                  color: Colors.red[800],
                  child: Text('حذف'),
                )),
          ],
        ),
      );
    });
    return data;
  }
}
