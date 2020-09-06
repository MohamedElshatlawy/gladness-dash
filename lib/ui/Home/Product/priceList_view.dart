import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/CommonCollections.dart';
import 'package:qutub_dashboard/API/products.dart';
import 'package:qutub_dashboard/models/productModel.dart';
import 'package:qutub_dashboard/models/vendorModel.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../../colors.dart';

class PriceListView extends StatefulWidget {
  VendorModel vendorModel;
  PriceListView(this.vendorModel);
  @override
  _PriceListViewState createState() => _PriceListViewState();
}

class _PriceListViewState extends State<PriceListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColor.customColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: MyColor.whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Text(
              "قائمة اسعار",
              style: TextStyle(color: MyColor.customColor),
            ),
            SizedBox(
              width: 5,
            ),
            Text(widget.vendorModel.name, style: TextStyle(color: MyColor.customColor))
          ],
        ),
        centerTitle: true,
      ),
         body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            margin: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
                  .collection(MyCollections.products)
                  .where("vendorID", isEqualTo: widget. vendorModel.id)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
                if (snapSHot.hasError)
                  return new Text('خطأ: ${snapSHot.error}');
                switch (snapSHot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.none:
                    return Center(
                      child: Text('لايوجد اتصال بالأنترنت'),
                    );
                  case ConnectionState.active:

                  case ConnectionState.done:
                    print(
                        "Len:${snapSHot.data.docs[0].data()['priceList'].length}");
                    return (snapSHot.data.docs.isEmpty)
                        ? Center(
                            child: Text('لا يوجد قائمة اسعار'),
                          )
                        : Column(
                            children: <Widget>[
                              CustomButton(
                                backgroundColor: MyColor.customColor,
                                btnPressed: () async {
                                     String productName;
                                await showDialog(
                                    context: context,
                                    builder: (ctx) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text('اسم المنتج'),
                                            content: TextField(
                                              onChanged: (v) {
                                                productName = v;
                                              },
                                              autofocus: true,
                                              keyboardType: TextInputType
                                                 .text,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            MyColor.customColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                            ),
                                            actions: <Widget>[
                                              RaisedButton(
                                                onPressed: () async {
                                                  if (productName != null) {
                                                    Navigator.pop(ctx);
                                                                 String price;
                                await showDialog(
                                    context: context,
                                    builder: (ctx) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text('سعر المنتج'),
                                            content: TextField(
                                              onChanged: (v) {
                                                price = v;
                                              },
                                              autofocus: true,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                decimal: false,
                                                signed: false,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'ادخل السعر باللغة الأنجليزية مثل 300',
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            MyColor.customColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                            ),
                                            actions: <Widget>[
                                              RaisedButton(
                                                onPressed: () async {
                                                  if (price != null) {
                                                  
                                                       var nums=['0','1','2','3','4','5','6','7','8','9'];
                                                       bool found=false;
                                                       for(int i=0;i<price.length;i++){
                                                         if(!nums.contains(price[i])){
                                                           found=true;
                                                           break;
                                                         }
                                                       }
                                                       if(found==false){
                                                                   Navigator.pop(ctx);
                                                    //  print(price);
                                                                             showMyDialog(
                                                            context: ctx,
                                                            msg:
                                                                'جاري اضافة منتج جديد');
                                                        await insertNewProduct(
                                                          price: price,
                                                          productName: productName,
                                                           
                                                            productModel: ProductModel.fromJson(
                                                                id: snapSHot
                                                                    .data
                                                                    .docs[
                                                                        0]
                                                                    .id,
                                                                json: snapSHot
                                                                    .data
                                                                    .docs[
                                                                        0]
                                                                    .data())).then((value){
                                                                   
                                                                      dismissDialog(context);
                                                                    }).catchError((e){
                                                                          
                                                                      dismissDialog(context);
                                                                  print('ErrorAddNewPriceList:$e');
                                                                    });
                        
                                                       }else{
                                                         
                                                       }
                                                 
                                             
                                                   
                                                    }
                                                },
                                                color: Colors.blue,
                                                child: Text('تأكيد'),
                                              )
                                            ],
                                          ),
                                        ));
                    
                                                  }
                                                },
                                                color: Colors.blue,
                                                child: Text('تأكيد'),
                                              )
                                            ],
                                          ),
                                        ));
                            
                          



                                
                                },
                                textColor: Colors.white,
                                txt: 'إضافة منتج جديد',
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  
                                    itemCount: snapSHot.data.docs[0]
                                        .data()['priceList'].length,
                                    itemBuilder: (ctx, index) {
                                      var prodModel = ProductModel.fromJson(
                                          id: snapSHot
                                              .data.docs[0].id,
                                          json:
                                              snapSHot.data.docs[0].data());
                                     return ListTile(
                                       title: Text(prodModel.priceList.keys.toList()[index]),
                                       subtitle: Text(prodModel.priceList.values.toList()[index]+" ريال"),
                                       trailing: IconButton(icon: Icon(Icons.delete),
                                        onPressed: () async {
                                           showMyDialog(
                                    context: context, msg: 'جاري حذف المنتج');
                                await removeProduct(prodModel, index,
                                true
                                )
                                    .then((value) {
                             
                                  dismissDialog(context);
                                }).catchError((e) {
                                  dismissDialog(context);
                                  print('ErrorRemoveProduct:$e');
                                });
                                        }),
                                     );
                                    }),
                              ),
                            ],
                          );
                }
                return Container();
              },
            )),
      ),
  
    );
  }
}