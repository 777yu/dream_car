import 'package:dream_car/login_page.dart';
import 'package:dream_car/main.dart';
import 'package:dream_car/tabs/all_order.dart';
import 'package:dream_car/tabs/one_order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("个人信息"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 20, bottom: 15),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 70.0,
                  width: 70.0,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: CircleAvatar(
                    //圆角图片
                    backgroundImage: AssetImage("images/head.jpg"),
                  ),
                ),
                Text(
                  USEANAME,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 280,
            child: ListView(
              children: <Widget>[
                _card("未完成订单",click: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return OneOrderPage();
                  }));
                }),
                _card("历史订单记录",click: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return AllOrderPage();
                  }));
                }),
                _service("版本信息", "0.0.1"),
                _service("联系客服", "0051-0213"),
                //退出登录
                Container(
                  height: 40.0,
                  margin: EdgeInsets.only(top: 20,bottom: 10),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 2.0,
                            color: Colors.white),
                      ),
                      color: Colors.orange,
                      onPressed: () async{
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('username');
                        prefs.remove('Authorization');
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                          return Login_Page();
                        }), (check) => false);
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Card _card(String str, {double top = 0.0,click}) {
  return Card(
    child: GestureDetector(
      onTap: click,
      child: Container(
        height: 50,
        color: Colors.white,
        margin: EdgeInsets.only(top: top),
        child: ListTile(
            title: Text(str), trailing: Icon(Icons.keyboard_arrow_right)),
      ),
    ),
  );
}

Card _service(String str, String info) {
  return Card(
    child: Container(
      height: 50,
      color: Colors.white,
      child: ListTile(title: Text(str), trailing: Text(info)),
    ),
  );
}
