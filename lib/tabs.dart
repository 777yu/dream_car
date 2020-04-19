import 'package:dream_car/Util/httpuital.dart';
import 'package:dream_car/tabs/order_page.dart';
import 'package:dream_car/tabs/home_page.dart';
import 'package:dream_car/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:convert';
import 'package:dream_car/Util/ToolTip.dart';
class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<BottomNavigationBarItem> _bottomItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(" ")),
    BottomNavigationBarItem(icon: Icon(Icons.perm_identity), title: Text("我的")),
  ];
  List tabs = [
    HomePage(),
    null,
    MyPage(),
  ];

  //当前选中的哪个
  int _currentIndex = 0;

  //显示的界面
  var _currentpage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _currentpage = HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentpage,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItem,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _currentpage = tabs[index];
          });
        },
      ),
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        margin: EdgeInsets.only(top: 14),
        child: FloatingActionButton(
          elevation: 0,
          child: Image(image: AssetImage("images/sao.png"),width: 38,height: 38,),
          onPressed: () async {
//            String result = await _scan();
//            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return OrderPage(result);
//            }));
            HttpUtil htp = new HttpUtil(header: headers);
            var re  =await htp.get("/lease/noPayLease");
            if(re=="error"){
              //404处理情况
              ToolTip.myGetTip(context, "请求错误", "服务器地址找不到", "确定");
            }else{
              var resultt = json.decode(re);
              //获取到的订单信息
              var orderresult=resultt["data"];
              //获得的结果是空，则代表所有订单已经完成
              if(orderresult==null){
                String result = await _scan();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return OrderPage(result);
                }));
              }else{
                ToolTip.myGetTip(context, "你有未完成的订单", "请先支付未完成的订单", "确定");
              }
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

//扫描二维码
Future<String> _scan() async {
  String result = await scanner.scan();
  return result;
}
