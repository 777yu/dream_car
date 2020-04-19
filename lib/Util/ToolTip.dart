import 'package:flutter/material.dart';
class ToolTip{
   static void gitTip(BuildContext context,String text1,String text2,String text3){
        showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              text1,
              style: TextStyle(color: Colors.red),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(text2),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(text3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }).then((val) {
      print(val);
    });
  }
}