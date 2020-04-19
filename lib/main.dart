import 'package:dream_car/login_page.dart';
import 'package:dream_car/tabs.dart';
import 'package:flutter/material.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:dream_car/Util/httpuital.dart';
String USEANAME = '';
//第四次测试
void main()async{
  runApp(MyApp());
  await AmapService.init(
    iosKey: '7a04506d15fdb7585707f7091d715ef4',
    androidKey: '6337e0c7e0c0762c79e6922203916828',
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  //loginState是定义当前登录状态状态，0代表没有登录，1代表登录
  var loginState;
  Future _validateLogin() async{
    Future<dynamic> future = Future(()async{
      SharedPreferences prefs =await SharedPreferences.getInstance();
      return prefs.getString("Authorization");
    });
    future.then((val){
      if(val == null){
        setState(() {
          loginState = 0;
        });
      }else{
        setState(() {
          loginState = 1;
          headers = {
            "Accept":"application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":val,
          };
//          print("AUTHORIZATION"+AUTHORIZATION);
        });
      }
    }).catchError((_){
      print("catchError");
    });
    Future<dynamic> future1 = Future(()async{
      SharedPreferences prefs =await SharedPreferences.getInstance();
      return prefs.getString("username");
    });
    future1.then((val){
      if(val == null){

      }else{
        setState(() {
          USEANAME = val;
        });
      }
    }).catchError((_){
      print("catchError");
    });
//    print("loginState=$loginState");
  }
  @override
  void initState(){
    _validateLogin();
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dream_car',
      debugShowCheckedModeBanner: false,//去除debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:TabsPage(),
    );
  }
}
//loginState==0?Login_Page():TabsPage()
//loginState==0?Login_Page():TabsPage()





