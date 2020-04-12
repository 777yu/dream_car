import 'package:dream_car/Bean/httpuital.dart';
import 'package:dream_car/tabs/one_order.dart';
import 'package:dream_car/tabs/zujiesuccess.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
class OrderPage extends StatefulWidget {
  String result;

  OrderPage(this.result);

  @override
  _OrderPageState createState() => _OrderPageState(this.result);
}

class _OrderPageState extends State<OrderPage> {
  //扫码得到的结果
  String result;
  //是否可以租借
  int carState = 1;
  var disable = "0";//代表用户可以使用
  var _style = TextStyle(color: Colors.blue, fontSize: 20);
  var _style2 = TextStyle(color: Colors.red, fontSize: 20);

  _OrderPageState(this.result);

  //页面请求
  getZhujie() async {
    HttpUtil htp = new HttpUtil(header: headers);
    var re = await htp.get("/car/$result");
    var resultcar = json.decode(re);
    if(resultcar["code"]=='402'){
      setState(() {
        disable = resultcar["code"];
      });
    }else{
      setState(() {
        carState = resultcar["data"]["state"];
      });
    }
    //print("state${resultcar["data"]["state"]}");

  }

  @override
  void initState() {
    getZhujie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '车辆租借',
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Text(
                      disable == "402"?"用户提示":"车辆信息:",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      disable=="402"?"该账号已经被停用":carState == 0 ? "可以使用,请点击租车" : "车辆暂时不能使用",
                      style: carState == 0 ? _style : _style2,
                    )
                  ],
                ),
              ],
            )),
            Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.only(bottom: 10),
              //color: Colors.blue,
              child: RaisedButton(
                child: Text("确认租车"),
                color: carState == 0 ? Colors.blue : Colors.grey,
                textColor: Colors.white,
                onPressed: carState == 0
                    ? () async {
                        Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
                        await geolocator.checkGeolocationPermissionStatus();
                        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        var lon = position.longitude;
                        var lat = position.latitude;
//                        print(latlng.lat);
//                        print(latlng.lng);
                        HttpUtil htp = new HttpUtil(header: headers);
                        var re = await htp.post(
                          //要放小车的id
                            "/car/useCar/$result",
                            queryParameters: {
                              "longitude": lon,
                              "dimensionality": lat
                            });
                        var shiyongresult = json.decode(re);

                        //是否成功租车0代表成功租车
                        var isSuccess = shiyongresult["code"];
                        if (isSuccess == '0') {
                          print("租车成功");
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return ZuJieSuccess();
                          }));
                        } else {
                          showDialog<Null>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: new Text(
                                    '租车失败',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: new SingleChildScrollView(
                                    child: new ListBody(
                                      children: <Widget>[
                                        new Text('租车失败，可能正在使用小车，请重试'),
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
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
            )
          ],
        ));
  }
}
