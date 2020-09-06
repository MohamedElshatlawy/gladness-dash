// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qutub_dashboard/API/categories.dart';
// import 'package:qutub_dashboard/API/products.dart';
// import 'package:qutub_dashboard/API/vendors.dart';
// import 'package:qutub_dashboard/models/categoryModel.dart';
// import 'package:qutub_dashboard/models/productModel.dart';
// import 'package:qutub_dashboard/models/vendorModel.dart';
// import 'package:qutub_dashboard/ui/widgets/customButton.dart';
// import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
// import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

// import '../colors.dart';

// class AddProduct extends StatefulWidget {
//   @override
//   _AddProductState createState() => _AddProductState();
// }

// class _AddProductState extends State<AddProduct> {
//   TextEditingController productNameController = TextEditingController();

//   TextEditingController productDescriptionController = TextEditingController();

//   TextEditingController productPriceController = TextEditingController();
//   List<CategoryModel> cats = [];
//   List<VendorModel> vendors = [];

//   List<File> images = [];
//   CategoryModel selectedCategoryModel;
//   VendorModel selectedVendorModel;

//   var addProductKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getAllCateogriesFireStore().then((value) {
//       setState(() {
//         cats.addAll(value);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: addProductKey,
//         backgroundColor: MyColor.customGreyColor,
//         appBar: AppBar(
//           leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: MyColor.customColor,
//               ),
//               onPressed: () => Navigator.pop(context)),
//           backgroundColor: MyColor.whiteColor,
//           title: Text(
//             'اضافة منتج جديد',
//             style: TextStyle(color: MyColor.customColor),
//           ),
//           centerTitle: true,
//         ),
//         body: Directionality(
//           textDirection: TextDirection.rtl,
//           child: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[400]),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: DropdownButton<CategoryModel>(
//                       onChanged: (val) {
//                         setState(() {
//                           selectedCategoryModel = val;

//                           vendors.clear();
//                           selectedVendorModel = null;
//                           getAllVendorsFromCategory(selectedCategoryModel.id)
//                               .then((vendrosData) {
//                             setState(() {
//                               vendors.addAll(vendrosData);
//                             });
//                           });
//                         });
//                       },
//                       value: selectedCategoryModel,
//                       hint: Text('اختر القسم'),
//                       icon: Icon(Icons.arrow_drop_down),
//                       isExpanded: true,
//                       items: cats.map<DropdownMenuItem<CategoryModel>>(
//                           (CategoryModel value) {
//                         return DropdownMenuItem<CategoryModel>(
//                           value: value,
//                           child: Text(value.name),
//                         );
//                       }).toList(),
//                       underline: Container(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[400]),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: DropdownButton<VendorModel>(
//                       onChanged: (val) {
//                         setState(() {
//                           selectedVendorModel = val;
//                         });
//                       },
//                       value: selectedVendorModel,
//                       hint: Text('اختر التاجر'),
//                       icon: Icon(Icons.arrow_drop_down),
//                       isExpanded: true,
//                       items: vendors.map<DropdownMenuItem<VendorModel>>(
//                           (VendorModel value) {
//                         return DropdownMenuItem<VendorModel>(
//                           value: value,
//                           child: Text(value.name),
//                         );
//                       }).toList(),
//                       underline: Container(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   CustomTextField(
//                     controller: productNameController,
//                     txtLablel: 'اسم المنتج',
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   CustomTextField(
//                     controller: productPriceController,
//                     txtLablel: 'سعر المنتج',
//                     isNumber: true,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   CustomTextField(
//                     controller: productDescriptionController,
//                     lineCount: 4,
//                     txtLablel: 'وصف المنتج',
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     'اضافة صور',
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     'التنسيقات المدعومة هي jpeg و jpg و png. يجب ألا تتجاوز كل صورة 5 ميغابايت',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     height: (images.isEmpty) ? 50 : 75,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         CircleAvatar(
//                           backgroundColor: MyColor.whiteColor,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.add,
//                               color: MyColor.customColor,
//                             ),
//                             onPressed: () async {
//                               File img = await getImage();

//                               setState(() {
//                                 images.add(img);
//                               });
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Expanded(
//                           child: Container(
//                             child: ListView.builder(
//                               itemCount: images.length,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 return InkWell(
//                                   onTap: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (ctx) => AlertDialog(
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               content: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 child: Image.file(
//                                                   images[index],
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ));
//                                   },
//                                   child: Container(
//                                     width: 75,
//                                     decoration: BoxDecoration(
//                                         color: Colors.transparent,
//                                         borderRadius: BorderRadius.circular(8)),
//                                     child: Stack(
//                                       fit: StackFit.expand,
//                                       children: <Widget>[
//                                         Container(
//                                           margin: EdgeInsets.all(5),
//                                           child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               child: Image.file(
//                                                 images[index],
//                                                 fit: BoxFit.cover,
//                                               )),
//                                         ),
//                                         Align(
//                                             alignment: Alignment.topRight,
//                                             child: CircleAvatar(
//                                               radius: 10,
//                                               backgroundColor: Colors.red[800],
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     images.removeAt(index);
//                                                   });
//                                                 },
//                                                 child: Icon(
//                                                   Icons.close,
//                                                   color: Colors.white,
//                                                   size: 15,
//                                                 ),
//                                               ),
//                                             ))
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   CustomButton(
//                     backgroundColor: MyColor.customColor,
//                     btnPressed: () async {
//                       if (validateInput()) {
//                         showMyDialog(
//                             context: context, msg: 'جاري اضافة منتج جديد');
//                         await insertNewProduct(
//                                 imgs: images,
//                                 productModel: ProductModel(
//                                   vendorID: selectedVendorModel.id,
//                                   vendorName: selectedVendorModel.name,
//                                     categoryId: selectedCategoryModel.id,
//                                     categoryName: selectedCategoryModel.name,
//                                     description:
//                                         productDescriptionController.text,
//                                     name: productNameController.text,
//                                     price: productPriceController.text))
//                             .then((value) {
//                           dismissDialog(context);
//                           showSnackbarError(
//                               msg: 'تم اضافة المنتج بنجاح',
//                               scaffoldKey: addProductKey);
//                           setState(() {
//                             images.clear();
//                             selectedCategoryModel = null;
//                             selectedVendorModel=null;
//                             vendors.clear();
                            
//                             productNameController.clear();
//                             productPriceController.clear();
//                             productDescriptionController.clear();
//                           });
//                         }).catchError((e) {
//                           dismissDialog(context);
//                           print('ErrorInserNewProduct:$e');
//                         });
//                       }
//                     },
//                     textColor: MyColor.whiteColor,
//                     txt: 'تأكيد',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   bool validateInput() {
//     if (selectedCategoryModel == null) {
//       showSnackbarError(
//           msg: 'من فضلك قم بأختيار القسم', scaffoldKey: addProductKey);
//       return false;
//     } else if (selectedVendorModel == null) {
//       showSnackbarError(
//           msg: 'من فضلك قم بأختيار التاجر', scaffoldKey: addProductKey);
//       return false;
//     } else if (productNameController.text.isEmpty) {
//       showSnackbarError(msg: 'ادخل اسم المنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (productPriceController.text.isEmpty) {
//       showSnackbarError(msg: 'ادخل سعر المنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (productDescriptionController.text.isEmpty) {
//       showSnackbarError(msg: 'ضع وصف للمنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (images.isEmpty) {
//       showSnackbarError(msg: 'ضع صورة للمنتج', scaffoldKey: addProductKey);
//       return false;
//     }
//     return true;
//   }
// }
