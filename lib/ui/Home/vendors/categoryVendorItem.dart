import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/vendors.dart';
import 'package:qutub_dashboard/models/vendorModel.dart';
import 'package:qutub_dashboard/ui/Home/Product/categoryProducts.dart';
import 'package:qutub_dashboard/ui/Home/vendors/updateVendor.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../../colors.dart';

class CategoryVendorItem extends StatelessWidget {
  VendorModel vendorModel;
  CategoryVendorItem({this.vendorModel});
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (ctxt) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            vendorModel.name,
                            textAlign: TextAlign.right,
                          ),
                          Divider(),
                        ],
                      ),
                      actions: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            showMyDialog(
                                context: ctxt, msg: 'جاري حذف التاجر');
                            await removeVendor(vendorModel).then((value) {
                              dismissDialog(ctxt);
                              dismissDialog(ctxt);
                            }).catchError((e) {
                              dismissDialog(ctxt);
                              print('ErrorRemoveVendor:$e');
                            });
                          },
                          color: MyColor.whiteColor,
                          textColor: Colors.red[800],
                          child: Text('حذف'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            print("ID:${vendorModel.id}");
                            dismissDialog(ctxt);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => UpdateVendor(
                                          vendorModel,
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
                  builder: (ctx) => CategoryProducts(
                        vendorModel: vendorModel,
                      )));
        },
        child: Container(
        
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Opacity(
                opacity: .5,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      vendorModel.imgPath,
                      fit: BoxFit.cover,
                    )),
              ),
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
                        vendorModel.name,
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
      ),
    );
  }
}
