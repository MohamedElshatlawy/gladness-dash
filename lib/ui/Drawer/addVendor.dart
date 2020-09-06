import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/categories.dart';
import 'package:qutub_dashboard/API/vendors.dart';
import 'package:qutub_dashboard/models/categoryModel.dart';
import 'package:qutub_dashboard/models/vendorModel.dart';
import 'package:qutub_dashboard/models/vendorNonRegularHolidaysModel.dart';
import 'package:qutub_dashboard/ui/Drawer/NonRegularHolidayDialog.dart';

import 'package:qutub_dashboard/ui/Drawer/regularHolidaysDialog.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class AddVendor extends StatefulWidget {
  @override
  _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  TextEditingController venderNameController = TextEditingController();

  TextEditingController venderMailController = TextEditingController();

  TextEditingController venderPhoneController = TextEditingController();

  TextEditingController venderPhone2Controller = TextEditingController();

  TextEditingController commRecordController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  File img;
  var addVendorKey = GlobalKey<ScaffoldState>();
  CategoryModel selectedCategoryModel;
  List<CategoryModel> cats = [];
  Map<String, String> priceList = {};
  List<File> gallery=[];
  
  Map<String, bool> days = {
    'الجمعة': false,
    'السبت': false,
    'الأحد': false,
    'الأثنين': false,
    'الثلاثاء': false,
    'الأربعاء': false,
    'الخميس': false,
  };
  Map<String,Map<String,String>> dateTime = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCateogriesFireStore().then((value) {
      setState(() {
        cats.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: addVendorKey,
        backgroundColor: MyColor.customGreyColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: MyColor.customColor,
              ),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: MyColor.whiteColor,
          title: Text(
            'اضافة تاجر جديد',
            style: TextStyle(color: MyColor.customColor),
          ),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<CategoryModel>(
                      onChanged: (val) {
                        setState(() {
                          selectedCategoryModel = val;
                        });
                      },
                      value: selectedCategoryModel,
                      hint: Text('اختر القسم'),
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: cats.map<DropdownMenuItem<CategoryModel>>(
                          (CategoryModel value) {
                        return DropdownMenuItem<CategoryModel>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      underline: Container(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: venderNameController,
                    txtLablel: 'اسم التاجر',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: venderMailController,
                    txtLablel: 'البريد الألكتروني',
                    isMail: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: venderPhoneController,
                    txtLablel: 'رقم الهاتف',
                    isNumber: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: venderPhone2Controller,
                    txtLablel: 'رقم هاتف اضافي ( اختياري ) ',
                    isNumber: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: commRecordController,
                    txtLablel: 'رقم السجل التجاري',
                    isNumber: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: bioController,
                    txtLablel: 'نبذة مختصرة عن التاجر',
                    lineCount: 3,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'اضف صورة التاجر',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'التنسيقات المدعومة هي jpeg و jpg و png. يجب ألا تتجاوز كل صورة 5 ميغابايت',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: (img == null) ? 50 : 75,
                    //height: 75,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              (img == null) ? Icons.add : Icons.edit,
                              color: MyColor.customColor,
                            ),
                            onPressed: () {
                              getImage().then((value) {
                                if (value != null) {
                                  setState(() {
                                    img = value;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        (img == null)
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            content: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                img,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ));
                                },
                                child: Container(
                                  width: 75,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              img,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.red[800],
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  img = null;
                                                });
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                     Text(
                    'اضف صور معرض التاجر',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                   Container(
                    height: (gallery.isEmpty) ? 50 : 80,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
                              File img = await getImage();
                              if (img != null) {
                                  setState(() {
                                                      gallery.add(img);
                                                    });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemCount: gallery.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                              ),
                                              content: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                child: Image.file(
                                                  gallery[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                               gallery[index],
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.red[800],
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                   gallery.removeAt(index);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'اضف قائمة اسعار التاجر',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                   CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
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
                                                onPressed: () {
                                                  if (price != null) {
                                                    Navigator.pop(ctx);
                                                    //  print(price);
                                                    setState(() {
                                                      priceList[productName] = price;
                                                    });
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
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                  //pricelist
                    ...getPriceListWidgets(),

                
                  Text(
                    'مواعيد الأجازة المنتظمة',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: MainHolidaysDialog(days, this,false)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (ctx, index) => SizedBox(
                              width: 10,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) => RaisedButton(
                              elevation: 0,
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {},
                              child: Text(resetSelectedDays()[index]),
                            ),
                            itemCount: resetSelectedDays().length,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'مواعيد الأجازة الغير المنتظمة',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.whiteColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: MyColor.customColor,
                            ),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: NonRegularHolidayDialog(
                                          dateTime, this)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ////////////////////
                        ///
                      ],
                    ),
                  ),
                  ...getUnRegularHolidays(),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    backgroundColor: MyColor.customColor,
                    btnPressed: () async {
                      if (validateInput()) {
                        showMyDialog(
                            context: context, msg: 'جاري اضافة تاجر جديد');
                        await insertNewVendor(
                          regularHolidays: resetSelectedDays(),
                          nonRegulars: dateTime,
                           // images: images,
                            profileImg: img,
                            priceList: priceList,
                            gallery: gallery,
                            vendorModel: VendorModel(
                              bio: bioController.text,
                              categoryID: selectedCategoryModel.id,
                              categoryName: selectedCategoryModel.name,
                              commRec: commRecordController.text,
                              email: venderMailController.text,
                              name: venderNameController.text,
                              optionalPhone: venderPhone2Controller.text,
                              phone: venderPhoneController.text,
                            )).then((value) {
                          dismissDialog(context);
                          showSnackbarError(
                              msg: 'تم اضافة التاجر بنجاح',
                              scaffoldKey: addVendorKey);
                          setState(() {
                            days.forEach((key, value) { 
                              value=false;
                            });
                            dateTime.clear();
                            img = null;
                          //  images.clear();
                          gallery.clear();
                          priceList.clear();
                            selectedCategoryModel = null;
                            bioController.clear();
                            commRecordController.clear();
                            venderMailController.clear();
                            venderNameController.clear();
                            venderPhoneController.clear();
                            venderPhone2Controller.clear();
                          });
                        }).catchError((e) {
                          dismissDialog(context);
                          print('ErrorInserNewVendor:$e');
                        });
                      }
                    },
                    textColor: MyColor.whiteColor,
                    txt: 'تأكيد',
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool validateInput() {
    if (selectedCategoryModel == null) {
      showSnackbarError(
          msg: 'من فضلك قم بأختيار القسم', scaffoldKey: addVendorKey);
      return false;
    }
    if (venderNameController.text.isEmpty ||
        venderMailController.text.isEmpty ||
        venderPhoneController.text.isEmpty ||
        commRecordController.text.isEmpty ||
        bioController.text.isEmpty) {
      showSnackbarError(
          msg: 'ادخل بيانات التاجر كاملة', scaffoldKey: addVendorKey);
      return false;
    } else if (img == null) {
      showSnackbarError(
          msg: 'قم بأرفاق صورة التاجر', scaffoldKey: addVendorKey);
      return false;
    }
    else if (gallery.isEmpty) {
      showSnackbarError(
          msg: 'قم معرض صور التاجر', scaffoldKey: addVendorKey);
      return false;
    }
     else if (priceList.isEmpty) {
      showSnackbarError(
          msg: 'قم بأرفاق قائمة أسعار التاجر', scaffoldKey: addVendorKey);
      return false;
    }
    return true;
  }

  List resetSelectedDays() {
    List<String> selectedDays = [];

    days.forEach((key, value) {
      if (value == true) {
        selectedDays.add(key);
      }
    });
    return selectedDays;
  }
List<Widget> getUnRegularHolidays() {
    List<Widget> data = [];
    dateTime.forEach((key, value) {
      data.add(
        ExpansionTile(
          title: Text(key),
          children: <Widget>[
            Container(
              height: 47,
              child: RaisedButton(
                  textColor: Colors.white,
                  onPressed: () {},
                  color: MyColor.customColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('الفترة من : '),
                          SizedBox(
                            width: 10,
                          ),
                          Text(value['from'])
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('الفترة إلى : '),
                          SizedBox(
                            width: 10,
                          ),
                          Text(value['to'])
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
                height: 47,
                child: RaisedButton(
                  textColor: Colors.white,
                  onPressed: () {
                    dateTime.remove(key);
                    setState(() {});
                  },
                  color: Colors.red[800],
                  child: Text('حذف'),
                )),
          ],
        ),
      );
    });
    return data;
  }


  List<Widget> getPriceListWidgets() {
    List<Widget> data = [];
    priceList.forEach((key, value) {
      data.add(
        ListTile(
          title: Text(key),
          subtitle: Text(value),
          trailing: IconButton(icon: Icon(Icons.delete),
           onPressed: (){
             setState(() {
               priceList.remove(key);
             });
           }),
        )
      );
    });
    return data;
  }


}
