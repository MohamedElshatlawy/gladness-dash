import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:qutub_dashboard/models/vendorNonRegularHolidaysModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class NonRegularHolidayDialog extends StatefulWidget {
  Map<String,dynamic> map;
  var parentWidget;
  NonRegularHolidayDialog(this.map, this.parentWidget);

  @override
  _NonRegularHolidayDialogState createState() =>
      _NonRegularHolidayDialogState();
}

class _NonRegularHolidayDialogState extends State<NonRegularHolidayDialog> {
  String pickedDate = "";
  String fromTime = "";
  String toTime = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 48,
            child: RaisedButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    locale: LocaleType.ar,
                    minTime: DateTime.now(), onConfirm: (v) {
                  pickedDate = v.toString().split(' ')[0];
                  print(pickedDate);
                  setState(() {});
                });
              },
              color: MyColor.customColor,
              textColor: Colors.white,
              child:
                  Text((pickedDate.isEmpty) ? 'قم بتحديد التاريخ' : pickedDate),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 48,
            child: RaisedButton(
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    showSecondsColumn: false,

                    locale: LocaleType.ar, onConfirm: (v) {
                  List<String> t = v.toString().split(' ')[1].split(".");
                  fromTime=t[0].split(":")[0]+":"+t[0].split(":")[1];
                  print(fromTime);
                  setState(() {});
                });
              },
              color: MyColor.customColor,
              textColor: Colors.white,
              child: Text((fromTime.isEmpty) ? 'الفترة من' : fromTime),
            ),
          )
         ,   SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 48,
            child: RaisedButton(
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    showSecondsColumn: false,

                    locale: LocaleType.ar, onConfirm: (v) {
                  List<String> t = v.toString().split(' ')[1].split(".");
                  toTime=t[0].split(":")[0]+":"+t[0].split(":")[1];
                  print(toTime);
                  setState(() {});
                });
              },
              color: MyColor.customColor,
              textColor: Colors.white,
              child: Text((toTime.isEmpty) ? 'الفترة إلى' : toTime),
            ),
          )
        ,   SizedBox(
            height: 20,
          ),

          Container(
            height: 48,
            width: double.infinity,
            child: RaisedButton(onPressed: (){
              if(pickedDate.isNotEmpty&&fromTime.isNotEmpty&&toTime.isNotEmpty){
                widget.map[pickedDate]=NonRegularHolidatTime(fromTime, toTime).toMap();
                
                widget.parentWidget.setState((){});
                dismissDialog(context);
              }
            },
            child: Text('تأكيد'),
            textColor: Colors.green[600],
            ),
          )
           ,SizedBox(
            height: 10,
          ),

          Container(
            height: 48,
            width: double.infinity,
            child: RaisedButton(onPressed: (){
              dismissDialog(context);
            },
            child: Text('رجوع'),
            textColor: Colors.red[800],
            ),
          )
        ],
      ),
    );
  }
}
