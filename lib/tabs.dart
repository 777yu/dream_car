import 'package:dream_car/Bean/httpuital.dart';
import 'package:dream_car/order_page.dart';
import 'package:dream_car/tabs/home_page.dart';
import 'package:dream_car/tabs/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:convert';
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
            }else{
              var resultt = json.decode(re);
              var aaa=resultt["data"];
              //获得的结果是空，则代表所有订单已经完成
              if(aaa==null){
                String result = await _scan();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return OrderPage(result);
                }));
              }else{
                showDialog<Null>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text(
                          '你有未完成的订单',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              new Text('请先支付未完成的订单'),
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
