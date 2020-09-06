
import 'package:flutter/material.dart';

import 'package:qutub_dashboard/models/productModel.dart';

import 'package:qutub_dashboard/ui/widgets/customButton.dart';


class ProductDetails extends StatefulWidget {
 ProductModel productModel;
  int index;
  ProductDetails(this.productModel,this.index);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}


class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/3,
                child: Image.network(
                  widget.productModel.priceList.keys.toList()[widget.index],
                  fit: BoxFit.fill,
                ),
              )
              ,SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text('')
                ],
              ),
              CustomButton(
                backgroundColor: Colors.green[600],
                btnPressed: (){},
                textColor: Colors.white,
                txt: 'تعديل',
              ),
              SizedBox(
                height: 10,
              ),
                CustomButton(
                backgroundColor: Colors.red[800],
                btnPressed: (){},
                textColor: Colors.white,
                txt: 'حذف',
              )
            ],
         ),
        ),
      ),
    );
  }
}
