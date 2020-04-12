import 'package:dream_car/Bean/httpuital.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
void main()async{
//  HttpUtil htp = new HttpUtil(header: headersJson);
//  var re = await htp.get("/ipp");
//  print(re is String);
//  print(re);
//  if(re=="error"){
//    print("界面请求错误");
//  }else{
//    var result = json.decode(re);
//    print(result);
//    print(result is Map);


//  int a = 12;
//
//  aaa();
//  print(a);
  String username = "小王";
  int password = 12345;
  Dio dio = new Dio();
  Response response = await dio.get("http://localhost:8080/login",queryParameters: {"username":username,"password":password});
  //print(response.data);
  var result = response.data;
  String cc = json.encode(result);
//  print("cc=$cc");
//  print(cc is String);

  Map map = json.decode(cc);
  print("map=$map");
//  print(map is Map);
  if(map["code"]=="0"){
    print(map["msg"]);
  }else{
    print(map["data"][0]["姓名"]);
    print(result["data"][0]["最爱"]);
    print(result["data"][1]);
  }

//  print(result is Map);
//  print(result["code"]);
  }
 aaa()async{
//   Timer timer = new Timer(new Duration(seconds: 10), () {
//     // 只在倒计时结束时回调
//   });
  await bbb();
  print("aaa");
}
Future bbb()async{
  Timer timer = new Timer(new Duration(seconds: 10), await () {
      print("bbb");
   });
  print("cab");
}
//  Response  response;
//  Dio dio = new Dio(BaseOptions(responseType:ResponseType.plain,));
//  response = await dio.get("https://httpbin.org/ipp");
//  print(response.statusCode);
//  print("baiima${response.statusCode}");
  //print(response.data);
//  print(response is String);
//  print(response);
//  print(response.data is Map);
//  print(response.data);
