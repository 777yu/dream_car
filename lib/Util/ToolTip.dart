import 'package:flutter/material.dart';
class ToolTip{
   static void aatip(BuildContext context){
        showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '请求错误',
              style: TextStyle(color: Colors.red),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('服务器地址找不到'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
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