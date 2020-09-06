import 'package:flutter/material.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class MainHolidaysDialog extends StatefulWidget {
  Map<String, bool> days;
  var parentWidget;
  bool isUpdate;
  MainHolidaysDialog(this.days,this.parentWidget,this.isUpdate);
  @override
  _MainHolidaysDialogState createState() => _MainHolidaysDialogState();
}

class _MainHolidaysDialogState extends State<MainHolidaysDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[...allWidgets(),
        
         Container(
          width: double.infinity,
          child: RaisedButton(onPressed: (){
            dismissDialog(context);
          },
          color: MyColor.customColor,
          textColor: Colors.white,
          child: Text('رجوع'),
          ),
        )
      
        ],
      ),
     
    );
  
  }

  List<Widget> allWidgets() {
    List<Widget> data = [];
    widget.days.forEach((key, value) {
      data.add(
        CheckboxListTile(
          value: value,
          activeColor: Colors.pink,
          onChanged: (v) {
            setState(() {
              widget.days[key] = v;
             
            });
           
 widget.parentWidget.setState((){});
            
            
          },
          title: Text(key),
        ),
      );
    });
    return data;
  }
}
