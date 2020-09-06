import 'package:flutter/foundation.dart';
import 'package:qutub_dashboard/API/categories.dart';
import 'package:qutub_dashboard/models/categoryModel.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> cats = [];
  CategoryProvider() {
    getAllCateogriesFireStore().then((value) {
      cats.addAll(value);
      notifyListeners();
    });
  }

  void addCategory(CategoryModel categoryModel){
    cats.add(categoryModel);
     notifyListeners();
  }
}
