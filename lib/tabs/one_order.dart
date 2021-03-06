import 'package:flutter/material.dart';
import 'package:dream_car/Util/httpuital.dart';
import 'dart:convert';
import 'package:tobias/tobias.dart';
class OneOrderPage extends StatefulWidget {
  @override
  _OneOrderPageState createState() => _OneOrderPageState();
}
class _OneOrderPageState extends State<OneOrderPage> {
  var style = TextStyle(fontSize: 22);
  var style2 = TextStyle(fontSize: 22, color: Colors.blue);
  //小车的id
  String _payInfo = "";
  Map _payResult;
  //请求结果
  var ResultData;
  //骑行时间
  int carTime = 10;
  //付钱金额
  double money = 10;
  var resultStatus = "1";//支付返回的结果
  var logging = "1";//显示加载中
  var error = "true";
  //获取订单信息
  void _loadData() async {
    _payInfo = "";
    _payResult = {};
    HttpUtil htp = new HttpUtil(header: headers);
    var re = await htp.get("/lease/noPayLease");
    if (re == "error") {
      setState(() {
        error = "error";
      });
    } else {
      var resultt = json.decode(re);
//    String rrre = resultt["data"];
//    print("rre++++++++$rrre");
      setState(() {
        logging = "2";
        ResultData = resultt["data"];
        if (ResultData != null) {
          _payInfo = resultt["data"]["payInfo"];
          carTime = resultt["data"]["totalTime"];
          money = resultt["data"]["fee"];
        }
      });
    }
  }

  @override
  initState() {
    super.initState();

    _loadData();
//    isAliPayInstalled().then((data){
//      print("installed $data");
//    });
  }
  //支付函数
  callAlipay() async {
    Map payResult;
    try {
      print("The pay info is : " + _payInfo);
      payResult = await aliPay(_payInfo, evn: AliPayEvn.SANDBOX);
      print("--->$payResult");
    } on Exception catch (e) {
      payResult = {};
    }

    if (!mounted) return;

    setState(() {
      _payResult = payResult;
      resultStatus = _payResult["resultStatus"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("未完成的订单"),
      ),
      body: error == "error"
          ? getError("加载失败，请返回")
          : logging == "1"
              ? getLoading()
              : resultStatus == "9000"
                  ? getError("完成支付，请返回")
                  : ResultData != null || resultStatus == "6001"
                      ?getOrder(carTime,money,callAlipay: callAlipay)
                      : Center(child: Text("恭喜你，完成所有的订单",style: style2,)),
    );
  }
}
//加载失败
Center getError(String str) {
  return Center(
    child: Text(str, style: TextStyle(fontSize: 22)),
  );
}

//加载中
Center getLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
//得到订单信息
Column getOrder(int carTime,double money,{callAlipay}){
  return  Column(
    children: <Widget>[
      Expanded(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("待支付订单",style: TextStyle(fontSize: 22,color: Colors.blue),)
                ],
              ),
              SizedBox(
                height: 28,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "骑行时间：",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    carTime.toString() + "分钟",
                    style: TextStyle(
                        fontSize: 24, color: Colors.blue),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "支付金额：",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    money.toString() + "元",
                    style: TextStyle(
                        fontSize: 24, color: Colors.blue),
                  )
                ],
              )
            ],
          )),
      Container(
        height: 50,
//            color: Colors.red,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              child: Text("确认支付"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(40))),
              onPressed: callAlipay,
            )
          ],
        ),
      )
    ],
  );
}