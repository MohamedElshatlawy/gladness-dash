import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/categories.dart';
import 'package:qutub_dashboard/models/categoryModel.dart';
import 'package:qutub_dashboard/ui/Drawer/updateCategory.dart';
import 'package:qutub_dashboard/ui/Home/Product/categoryProducts.dart';
import 'package:qutub_dashboard/ui/Home/vendors/categoryVendors.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class CategoryItem extends StatelessWidget {
  CategoryModel categoryModel;
  CategoryItem({this.categoryModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (ctxt) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          categoryModel.name,
                          textAlign: TextAlign.right,
                        ),
                        Divider(),
                      ],
                    ),
                    actions: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          showMyDialog(
                            context: ctxt,
                            msg: 'جاري حذف القسم'
                          );
                          await removeCategory(categoryModel)
                          .then((value) {
                            dismissDialog(ctxt);
                           dismissDialog(ctxt);
                          }).catchError((e){
                            dismissDialog(ctxt);
                            print('ErrorRemoveCategory:$e');
                          });
                        },
                        color: MyColor.whiteColor,
                        textColor: Colors.red[800],
                        child: Text('حذف'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          dismissDialog(ctxt);
                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>UpdateCategory(
                            categoryModel: categoryModel,
                          )));
                        },
                        color: MyColor.whiteColor,
                        textColor: Colors.green[600],
                        child: Text('تعديل'),
                      )
                    ],
                  ),
                ));
      },
      onTap: () { 
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => CategoryVendors(
                      categoryModel: categoryModel,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
                opacity: .5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    categoryModel.imgPath,
                    fit: BoxFit.cover,
                  ),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: RotatedBox(
                quarterTurns: -1,
                child: Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      categoryModel.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
