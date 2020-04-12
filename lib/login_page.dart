import 'package:dream_car/main.dart';
import 'package:dream_car/tabs.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_car/Bean/httpuital.dart';
import 'dart:convert';
class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
//   TextEditingController usernameController;
//定时器
  Timer countDownTimer;
  //获取验证码名字
  String yzmText="获取验证码";
//  TextEditingController passwordController;
  final registerFormKey = GlobalKey<FormState>();
  String username, password;
  var info;
  bool usernameAuto = false;
  @override
  void submitRegisterForm() async{
//    var http = new HttpUtil(header: headersJson);
//    var re = http.post("/user/login",data: {"phoneNumber":"$username","randCode":"$password"});

    //保存控制台输入的数据
    if( registerFormKey.currentState.validate()){
      registerFormKey.currentState.save();

     // userNameSave();

      //网络登录
      var aaa = new HttpUtil(header: headers);
      var re = await aaa.post("/user/login",queryParameters: {"phoneNumber":"$username","randCode":"$password"});
      if(re == "error"){
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
      }else {
        var result = jsonDecode(re);
        var isNo = result["code"];
        info = result["data"];
        //手动代码登录
//      var isNo = "0";
        if(isNo=="0"){
          print("登录成功");
          registerFormKey.currentState.reset();
          print("username;$username");
          print("password:$password");
          //保存用户姓名
          //"Authorization":AUTHORIZATION,
          USEANAME = username;
          //保存Authorization
//        AUTHORIZATION = info;
          headers = {
            "Accept":"application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":info,
          };
          userNameSave();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
            return TabsPage();
          }), (check) => false);
        }else{
          //跳出提示框
          showDialog<Null>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('验证码错误',style: TextStyle(color: Colors.red),),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text('验证码错误'),
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
            },
          ).then((val) {
            print(val);
          });
        }
      }

    }else{
      usernameAuto = true;
    }
  }
  //保存用户
 userNameSave() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", USEANAME);
    prefs.setString("Authorization", info);
  }
//验证手机号是否是11位
  String  validateUsername(value){
    if(value.toString().length!=11){
      return '请输入正确的手机号';
    }
    return null;
  }
  @override
  void dispose() {
    countDownTimer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            padding: EdgeInsets.only(top: 10),
            //color: Colors.orange,
            child: Image(
              image: AssetImage("images/logo.png"),
              width: MediaQuery.of(context).size.width / 6,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.only(left: 25.0, right: 20.0),
            child: Form(
              key: registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "username",
                      hintText: "请输入手机号",
                      //输入框背景颜色
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    //onSaved, 当调用FormState.save方法的时候调用
                    onSaved: (value) {
                      username = value;
                    },
//                    controller: usernameController,
                    validator: validateUsername,
                    autovalidate: usernameAuto,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
//                    controller: passwordController,
                    //obscureText: true,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.fast_forward),
                        labelText: 'verification',
                        hintText: "请输入验证码",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon:OutlineButton(
                          onPressed: yzmText=="获取验证码"?yzmGet:null,
                          padding: EdgeInsets.only(top: 0),
                          borderSide: BorderSide.none,
//                          highlightedBorderColor: Colors.blue,
                          child: new Text(yzmText),
                          textColor: Colors.blue,
                        ),

                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  //登录按钮
                  Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        '注册/登录',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 2),
                      ),
                      elevation: 0,
                      onPressed: submitRegisterForm,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  //获取验证码，判断
  yzmGet() async{
      if( registerFormKey.currentState.validate()){
        registerFormKey.currentState.save();
        var http = new HttpUtil(header: headers);
        var result =await http.get("/user/randCode",queryParameters:{"phoneNumber":"$username"});
        //var re = jsonDecode(result);
        countDownTimer?.cancel();//如果已存在先取消置空
        countDownTimer = null;
        countDownTimer = new Timer.periodic(new Duration(seconds: 1), (t){
          setState(() {
            if(60-t.tick>0){//60-t.tick代表剩余秒数，如果大于0，设置yzmText为剩余秒数，否则重置yzmText，关闭countTimer
              yzmText = "${60-t.tick}秒后重新获取";
            }else{
              yzmText = '获取验证码';
              countDownTimer.cancel();
              countDownTimer = null;
            }
          });
        });
      }else{
        usernameAuto = true;
      }
    }

}
