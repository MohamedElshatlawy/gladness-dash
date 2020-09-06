// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qutub_dashboard/API/categories.dart';
// import 'package:qutub_dashboard/API/products.dart';
// import 'package:qutub_dashboard/models/categoryModel.dart';
// import 'package:qutub_dashboard/models/productModel.dart';
// import 'package:qutub_dashboard/ui/widgets/customButton.dart';
// import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
// import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

// import '../colors.dart';

// class UpdateProduct extends StatefulWidget {
//   ProductModel productModel;
//   UpdateProduct({this.productModel});

//   @override
//   _UpdateProductState createState() => _UpdateProductState();
// }

// class _UpdateProductState extends State<UpdateProduct> {
//   TextEditingController productNameController = TextEditingController();

//   TextEditingController productDescriptionController = TextEditingController();

//   TextEditingController productPriceController = TextEditingController();
//   List<CategoryModel> cats = [];
//   List<File> images = [];
//   var selectedCategoryModel;
//   var addProductKey = GlobalKey<ScaffoldState>();
//   List<Widget> allImages = [];

//   List<Widget> getAllImages() {
//     allImages.clear();
//     widget.productModel.imgPaths.forEach((element) {
//       allImages.add(InkWell(
//         onTap: () {
//           showDialog(
//               context: context,
//               builder: (ctx) => AlertDialog(
//                     backgroundColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     content: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         element,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ));
//         },
//         child: Container(
//           width: 75,
//           height: 75,
//           decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(8)),
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.all(5),
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       element,
//                       fit: BoxFit.cover,
//                     )),
//               ),
//               Align(
//                   alignment: Alignment.topRight,
//                   child: CircleAvatar(
//                     radius: 10,
//                     backgroundColor: Colors.red[800],
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           widget.productModel.imgPaths.remove(element);
//                         });
//                       },
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 15,
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ));
//     });
//     if (images.isNotEmpty) {
//       images.forEach((element) {
//         allImages.add(InkWell(
//           onTap: () {
//             showDialog(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                       backgroundColor: Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       content: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(
//                           element,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ));
//           },
//           child: Container(
//             width: 75,
//             height: 75,
//             decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(8)),
//             child: Stack(
//               fit: StackFit.expand,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.all(5),
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         element,
//                         fit: BoxFit.cover,
//                       )),
//                 ),
//                 Align(
//                     alignment: Alignment.topRight,
//                     child: CircleAvatar(
//                       radius: 10,
//                       backgroundColor: Colors.red[800],
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             images.remove(element);
//                           });
//                         },
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                           size: 15,
//                         ),
//                       ),
//                     ))
//               ],
//             ),
//           ),
//         ));
//       });
//     }
//     /**/

//     return allImages;
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     productNameController.text = widget.productModel.name;
//     productDescriptionController.text = widget.productModel.description;
//     productPriceController.text = widget.productModel.price;

//     getAllCateogriesFireStore().then((value) {
//       cats.addAll(value);
//       cats.forEach((element) {
//         if (element.id == widget.productModel.categoryId) {
//           selectedCategoryModel = element;
//         }
//       });
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: addProductKey,
//          backgroundColor: MyColor.customGreyColor,
//         appBar: AppBar(
//            leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: MyColor.customColor,
//               ),
//               onPressed: () => Navigator.pop(context)),
//           backgroundColor: MyColor.whiteColor,
         
//           title: Text('تعديل ${widget.productModel.name}',style: TextStyle(
//             color: MyColor.customColor
//           ),),
//           centerTitle: true,
//         ),
//         body: Directionality(
//           textDirection: TextDirection.rtl,
//           child: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                CustomTextField(
//                     controller: TextEditingController(
//                       text: widget.productModel.categoryName
//                     ),
//                     txtLablel: 'القسم',
//                     isEdit: false,
//                   ),   SizedBox(
//                     height: 15,
//                   ),
//                   CustomTextField(
//                     controller: TextEditingController(
//                       text: widget.productModel.vendorName,
                      
//                     ),
//                     isEdit: false,
//                     txtLablel: 'التاجر',
//                   ),   SizedBox(
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
//                     'اضافة صورة',
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
//                     height: (images.isEmpty&&widget.productModel.imgPaths.isEmpty) ? 50 : 75,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         CircleAvatar(
//                           backgroundColor: MyColor.customColor,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.add,
//                               color: Colors.white,
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
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             children: [...getAllImages()],
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
//                         widget.productModel.categoryId=selectedCategoryModel.id;
//                         widget.productModel.categoryName=selectedCategoryModel.name;
//                         widget.productModel.name=productNameController.text;
//                         widget.productModel.price=productPriceController.text;
//                         widget.productModel.description=productDescriptionController.text;
                        
//                         showMyDialog(
//                             context: context, msg: 'جاري تعديل المنتج');
//                         await updateProduct(
//                                 imgs: images,
//                                 productModel:widget.productModel
                                    
//                                     )
//                             .then((value) {
//                           dismissDialog(context);
//                           Navigator.pop(context);
                      
//                         }).catchError((e) {
//                           dismissDialog(context);
//                           print('ErrorUpdateProduct:$e');
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
//     } else if (productNameController.text.isEmpty) {
//       showSnackbarError(msg: 'ادخل اسم المنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (productPriceController.text.isEmpty) {
//       showSnackbarError(msg: 'ادخل سعر المنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (productDescriptionController.text.isEmpty) {
//       showSnackbarError(msg: 'ضع وصف للمنتج', scaffoldKey: addProductKey);
//       return false;
//     } else if (images.isEmpty&&widget.productModel.imgPaths.isEmpty) {
//       showSnackbarError(msg: 'ضع صورة للمنتج', scaffoldKey: addProductKey);
//       return false;
//     }
//     return true;
//   }
// }
