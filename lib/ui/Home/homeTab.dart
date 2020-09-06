import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/categories.dart';
import 'package:qutub_dashboard/models/categoryModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/customHomeCategoriesItem.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
    FirebaseFirestore.instance.collection(MyCollections.categories).snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
    if (snapSHot.hasError) return new Text('خطأ: ${snapSHot.error}');
    switch (snapSHot.connectionState) {
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(MyColor.customColor),

          ),
        );

      case ConnectionState.none:
        return Center(
          child: Text('لايوجد اتصال بالأنترنت'),
        );
      case ConnectionState.active:

      case ConnectionState.done:
        return (snapSHot.data.docs.isEmpty)
            ? Center(
                child: Text('لا يوجد أقسام'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                itemCount: snapSHot.data.docs.length,
                itemBuilder: (ctx, index) {
                
                  CategoryModel model = CategoryModel(
                      id: snapSHot.data.docs[index].id,
                      name: snapSHot.data.docs[index].data()['name'],
                      imgPath:
                          snapSHot.data.docs[index].data()['imgPath']);
                  return CategoryItem(
                    categoryModel: model,
                  );
                },
              );
    }
    return Container();
        },
      );
 
  }
}
