import 'dart:convert';

import 'package:dream_car/Util/httpuital.dart';
import 'package:flutter/material.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AmapController _controller;
  //小车的经纬度
  List<double> lon = [];
  List<double> lat = [];
  //点集合
  List<Marker> _markers = [];
  //获取经纬度
  getJingwei() async{
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    await geolocator.checkGeolocationPermissionStatus();
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var longitude = position.longitude;
    var dimensionality = position.latitude;
    HttpUtil htp = new HttpUtil(header: headers);
    var re =await htp.post("/car/nearby",queryParameters: {"longitude":longitude,"dimensionality":dimensionality,"distance":2000.0});
    var reposition = json.decode(re);
    List positionList = reposition["data"];
    print("----------------------------------------------------------");
    print("positionList+$positionList");
    print("----------------------------------------------------------");
    for (int i = 0; i <positionList.length; i++) {
      lon.add(positionList[i]["longitude"]);
      lat.add(positionList[i]["dimensionality"]);
    }
//    print(lat);
//    print(lon);
  }
  List<MarkerOption> list = [];
  setMakerList(){
    print("setMakerLit启动");
    for (int i = 0; i <lon.length; i++){
      list.add(MarkerOption(
        latLng: LatLng(lat[i],lon[i]),
//        title: '北京',
//        snippet: '描述',
//            iconUri: i % 2 == 0 ? _assetsIcon1 : _assetsIcon2,
//            imageConfig: createLocalImageConfiguration(context),
      ));
    }
    print(list);
  }
  //绘制点
  getMake() async {
    print("getMake启动");
    setMakerList();
    final markers = await _controller?.addMarkers(list);
    _markers.addAll(markers);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('快走小车'), centerTitle: true),
      body: AmapView(
        zoomLevel:16.0,
        showZoomControl: false,
        maskDelay: Duration(milliseconds: 500),
        onMapCreated: (controller) async {
          _controller = controller;
          if (await requestPermission()) {
//            await controller.showMyLocation(true);
            await _controller?.showMyLocation(
              true,
              myLocationType: MyLocationType.Rotate,
            );
            //获取经纬度信息
            await getJingwei();
            //在界面绘制小车位置
            getMake();
//                      final latLng = await _controller?.getLocation(
//                          delay: Duration(seconds: 2));
//                      await enableFluttifyLog(false); // 关闭 log
//                      _loadData(latLng);
          }
        },
      ),
    );
  }
}

Future<bool> requestPermission() async {
  final permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);

  if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    return true;
  } else {
    print('需要定位权限!');
    return false;
  }
}
