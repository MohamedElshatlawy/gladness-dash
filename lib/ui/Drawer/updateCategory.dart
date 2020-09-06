import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qutub_dashboard/API/categories.dart';
import 'package:qutub_dashboard/models/categoryModel.dart';
import 'package:qutub_dashboard/ui/widgets/customButton.dart';
import 'package:qutub_dashboard/ui/widgets/customTextField.dart';
import 'package:qutub_dashboard/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class UpdateCategory extends StatefulWidget {
  CategoryModel categoryModel;
  UpdateCategory({this.categoryModel});
  @override
  _UpdateCategoryState createState() =>
      _UpdateCategoryState(this.categoryModel);
}

class _UpdateCategoryState extends State<UpdateCategory> {
  var updateCategoryKey = GlobalKey<ScaffoldState>();

  TextEditingController catNameController;
  CategoryModel categoryModel;
  _UpdateCategoryState(this.categoryModel) {
    catNameController = TextEditingController(text: categoryModel.name);
  }

  File img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.customGreyColor,
        key: updateCategoryKey,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: MyColor.customColor,), 
          onPressed: (){
            Navigator.pop(context);
          }),
          backgroundColor:MyColor.whiteColor,
          title: Text(widget.categoryModel.name,style: TextStyle(
            color: MyColor.customColor
          ),),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextField(
                    controller: catNameController,
                    txtLablel: 'اسم القسم',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'اضافة صورة',
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
                    height: (img == null&&widget.categoryModel.imgPath==null) ? 50 : 75,
                    //height: 75,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: MyColor.customColor,
                          child: IconButton(
                            icon: Icon( (img == null&&widget.categoryModel.imgPath==null) ?
                            Icons.add:
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              getImage().then((value) {
                                setState(() {
                                  img = value;
                                  widget.categoryModel.imgPath = null;
                                });
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        (img == null && widget.categoryModel.imgPath == null)
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
                                              child: (img == null)
                                                  ? Image.network(
                                                      widget.categoryModel
                                                          .imgPath,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
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
                                            child: (img == null)
                                                ? Image.network(
                                                    widget
                                                        .categoryModel.imgPath,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
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
                                                  widget.categoryModel.imgPath =
                                                      null;
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
                    height: 30,
                  ),
                  CustomButton(
                    backgroundColor: MyColor.customColor,
                    btnPressed: () async {
                      if (validateInput()) {
                        
                        showMyDialog(
                          context: context,
                          msg: 'جاري تعديل القسم'
                        );
                        categoryModel.name=catNameController.text;
                        await updateNewCategory(
                          categoryModel: categoryModel,
                          img: img
                        ).then((value) {
                          dismissDialog(context);
                          Navigator.pop(context);
                        }).catchError((e){
                          dismissDialog(context);
                          print('ErrorUpdateCategory:$e');
                        });
                      
                      }
                    },
                    textColor: MyColor.whiteColor,
                    txt: 'تعديل',
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool validateInput() {
    if (catNameController.text.isEmpty) {
      showSnackbarError(scaffoldKey: updateCategoryKey, msg: 'ادخل اسم القسم');
      return false;
    } else if (img == null&&widget.categoryModel.imgPath==null) {
      showSnackbarError(
          scaffoldKey: updateCategoryKey, msg: 'من فضلك قم بتحميل صورة للقسم');
      return false;
    }
    return true;
  }
}
