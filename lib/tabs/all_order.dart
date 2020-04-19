import 'package:dream_car/Util/httpuital.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
class AllOrderPage extends StatefulWidget {
  @override
  _AllOrderPageState createState() => _AllOrderPageState();
}

class _AllOrderPageState extends State<AllOrderPage> {
  List _allOrder;
  var error ="true";
  var loading = "1";
  var style = TextStyle(fontSize: 22);
  //获取所有订单信息
  _getAllOrder()async{
    HttpUtil stp = new HttpUtil(header: headers);
    var re = await stp.get("/lease/history");
    if(re=="error"){
      setState(() {
        error = "error";
      });
    }else{
      var reResult = json.decode(re);
      var OrderResult = reResult["data"];
      print(OrderResult);
      setState(() {
        _allOrder = OrderResult;
        loading = "2";
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllOrder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("历史订单信息"),
      ),
      body: error=="error"?Center(child:Text("加载失败，请返回",style: style,),):loading=="1"?Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: _allOrder.length,
        itemBuilder: (context,index){
          var oneOrder = _allOrder[index];
          return Column(
            children: <Widget>[
              ListTile(
                title: Text("金额：${oneOrder["expense"]}元"),
                subtitle: Text("开始时间：${oneOrder["statTimeStr"]}  耗时：${oneOrder["durationTime"]}分钟"),
                leading: Icon(Icons.fast_forward,color: Colors.blue,),
                contentPadding: EdgeInsets.symmetric(horizontal: 22.0),
                trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
              ),
              Divider()//下划线
            ],
          );
        },
      ),
    );
  }
}
