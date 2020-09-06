import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_dashboard/models/msgModel.dart';
import 'package:qutub_dashboard/ui/colors.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.customGreyColor,
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
        title: Text(
          "الرسائل",
          style: TextStyle(color: MyColor.customColor),
        ),
        centerTitle: true,
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("messages").snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
              if (snapSHot.hasError) {
                print(snapSHot.error);
                return new Text('خطأ: ${snapSHot.error}');
              }
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
                  return (snapSHot.data.docs.isEmpty)
                      ? Center(
                          child: Text('لا يوجد رسائل'),
                        )
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            var msg = MsgModel.fromJson(
                                snapSHot.data.docs[index].id,
                                snapSHot.data.docs[index].data());
                            return Card(
                              child: ExpansionTile(
                                title: Text(msg.name),
                                subtitle: Row(
                                  children: <Widget>[
                                    Text('${msg.phone} / '),
                                    Text('${msg.mail}'),
                                  ],
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${msg.msg}",
                                      style:
                                          TextStyle(color: MyColor.customColor),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: snapSHot.data.docs.length,
                        );
              }
              return Container();
            },
          )),
    );
  }
}
