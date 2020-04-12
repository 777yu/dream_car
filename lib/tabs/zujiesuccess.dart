import 'package:flutter/material.dart';

class ZuJieSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("租借成功"),
      ),
      body: Center(
        child: Text("租借成功,请返回",style: TextStyle(fontSize: 24,color: Colors.blue),),
      )
    );
  }
}
