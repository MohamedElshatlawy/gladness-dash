import 'package:flutter/material.dart';
import 'package:qutub_dashboard/ui/colors.dart';

class Common {
  static String domainName = "@gladness.com";
  static String reviewStatus = "review";
  static String acceptedStatus = "accept";
  static String rejectedStatus = "reject";
  static String confirmedStatus = "confirm";

  static var mappingColors = {
    reviewStatus: MyColor.customColor,
    rejectedStatus: Colors.red[800],
    acceptedStatus: Colors.blueGrey,
    confirmedStatus: Colors.green[600]
  };

  static var mappingStatus = {
    reviewStatus: 'تم استلام الطلب',
    rejectedStatus: 'الطلب مرفوض',
    acceptedStatus: 'قيد الانتظار',
    confirmedStatus: 'تم تأكيد الطلب'
  };
  static var mappingDayNames = {
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
    'Monday': 'الأثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
  };
}
