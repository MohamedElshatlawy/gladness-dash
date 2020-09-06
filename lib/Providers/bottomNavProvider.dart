import 'package:flutter/foundation.dart';

class BottomNavProvider extends ChangeNotifier{
  int selectedIndex=1;

  onTapClick(int index){
    selectedIndex=index;
    notifyListeners();
  }

  String getTabName(){
    switch(selectedIndex){
      case 1:
        return 'الرئيسية';
      case 0:
        return 'الطلبات';
    }
    return '';
  }
  
}