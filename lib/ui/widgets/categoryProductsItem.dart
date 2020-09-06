import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/products.dart';
import 'package:qutub_dashboard/models/productModel.dart';
import 'package:qutub_dashboard/ui/Home/Product/productDetails.dart';
import 'package:qutub_dashboard/ui/colors.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

class CategoryProductItem extends StatelessWidget {
  ProductModel productModel;
  int index;
  CategoryProductItem({this.productModel, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (ctxt) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(horizontal: 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      title: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                                              child: Image.network(
                                    productModel.galleryPaths[index],
                                    height: MediaQuery.of(context).size.height/2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                    ),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              onPressed: () async {
                                showMyDialog(
                                    context: ctxt, msg: 'جاري حذف الصورة');
                                await removeProduct(productModel, index,
                                false
                                )
                                    .then((value) {
                                  dismissDialog(ctxt);
                                  dismissDialog(ctxt);
                                }).catchError((e) {
                                  dismissDialog(ctxt);
                                  print('ErrorRemoveProduct:$e');
                                });
                              },
                              color: MyColor.whiteColor,
                              textColor: Colors.red[800],
                              child: Text('حذف'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                            Container(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              onPressed: () async {
                               dismissDialog(context);
                              },
                              color:Colors.red[800],
                              textColor: Colors.white,
                              child: Text('رجوع'),
                            ),
                          ),
                       
                        ],
                      ),
                      actions: <Widget>[],
                    ),
                  ));
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
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productModel.galleryPaths[index],
                      fit: BoxFit.cover,
                    )),
              ),
              //   Align(
              //     alignment: Alignment.centerLeft,
              //     child: RotatedBox(
              //       quarterTurns: -1,
              //       child: Container(
              //         width: 90,
              //         height: 30,
              //         decoration: BoxDecoration(
              //             color: Colors.red[800],
              //             borderRadius: BorderRadius.only(
              //                 bottomRight: Radius.circular(10),
              //                 bottomLeft: Radius.circular(10))),
              //         child: Center(
              //           child: Text(
              //             productModel.priceList.values.toList()[index],
              //             textAlign: TextAlign.center,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
