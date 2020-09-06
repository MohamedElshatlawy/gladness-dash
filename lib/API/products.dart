import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:qutub_dashboard/models/productModel.dart';

import 'CommonCollections.dart';

Future<List<String>> uploadProductsImages(List<File> images) async {
  List<String> imagesURL = [];

  await Future.forEach(images, (File myImage) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child(MyCollections.images)
        .child(basename(myImage.path));

    await storageReference.putFile(myImage).onComplete.then((taskSnap) async {
      imagesURL.add(await taskSnap.ref.getDownloadURL());
    });
  });

  return imagesURL;
}

Future<void> insertNewProduct(
    {File img,String price,String productName,ProductModel productModel}) async {
  


  if(price==null){
    //upload image

      String imageURL = "";
  final StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child(MyCollections.images)
      .child(basename(img.path));

  await storageReference.putFile(img).onComplete.then((taskSnap) async {
    imageURL = await taskSnap.ref.getDownloadURL();
  });
    //AddNewProduct
  productModel.galleryPaths.add(imageURL);

  return await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc(
        productModel.id
      )
      .update({"gallery":productModel.galleryPaths});
  }else{
    //updatePriceList

      //AddNewProduct
  productModel.priceList[productName]=price;

  return await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc(
        productModel.id
      )
      .update({"priceList":productModel.priceList});
  }
  
}

Future<void> removeProduct(ProductModel productModel, int index,bool isPriceList) async {
  if(isPriceList==true){
       productModel.priceList.remove(productModel.priceList.keys.toList()[index]);

  return await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc(productModel.id)
      .update({"priceList": productModel.priceList});
  }else{
    productModel.galleryPaths.removeAt(index);
  return await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc(productModel.id)
      .update({"gallery": productModel.galleryPaths});
  }
 
}

Future<List<ProductModel>> getAllProductsFire(String catID) async {
  List<ProductModel> products = [];

  await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .where('categoryID', isEqualTo: catID)
      .get()
      .then((value) => value.docs.forEach((element) {
            products.add(ProductModel.fromJson(
                id: element.id, json: element.data()));
          }));

  return products;
}

Future<void> updateProduct({ProductModel productModel, List<File> imgs}) async {
  var newPathsFiles;
  if (imgs.isNotEmpty) {
    newPathsFiles = await uploadProductsImages(imgs);
  }

  List<String> newProductPaths = [];

  //
  // productModel.imgPaths.forEach((element) {
  //   newProductPaths.add(element);
  // });
  if (newPathsFiles != null) {
    newProductPaths.addAll(newPathsFiles);
  }
  //

  await removeProduct(productModel, 0,false);

  // productModel.imgPaths.clear();
  // productModel.imgPaths.addAll(newProductPaths);

  return await FirebaseFirestore.instance
      .collection(MyCollections.products)
      .doc()
      .set(productModel.toMap());
}
