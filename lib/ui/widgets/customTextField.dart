import 'package:flutter/material.dart';

import '../colors.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String txtLablel;
  bool isNumber;
  bool isPassword;
  bool isMail;
  bool isEdit;
  var labelColor;
  var txtColor;

  int lineCount;
  CustomTextField(
      {this.controller,
      this.txtLablel,
      this.isNumber,
      this.isPassword,
      this.lineCount,
      this.labelColor,
      this.txtColor,
      this.isEdit,
      this.isMail});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color:(txtColor==null)? Colors.grey:txtColor
        ),
        cursorColor: MyColor.customColor,
        enabled: (isEdit==false)?false:true,
        
        obscureText: (isPassword==true) ? true : false,
        keyboardType: (isMail==true)
            ? TextInputType.emailAddress
            : (isNumber==true) ? TextInputType.number : TextInputType.text,
        maxLines: (lineCount!=null)?lineCount:1,
        scrollController: ScrollController(),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: InputBorder.none,
            
            alignLabelWithHint: (lineCount!=null)?true:false,
            labelText: txtLablel,
            labelStyle: TextStyle(color:(labelColor==null)? MyColor.customColor:labelColor,
            
            ),
            contentPadding: EdgeInsets.fromLTRB(8,5,8,5)),
      ),
    );
  }
}
