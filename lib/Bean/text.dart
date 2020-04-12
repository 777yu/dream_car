import 'package:dream_car/Bean/cha.dart';
import 'package:dream_car/Bean/login.dart';

String cc = '123';
void main()async{
//  cha();
//  print("aa");
//  login();
//  print("cc"+cc);
//  cha();

Map map = {
  "code": "0",
  "message": "SUCCESS",
  "data": [
    {
      "id": "369C7E87B02B44CD9D1E5AA6BEAB24AB",
      "qrId": "22399795636a11ea8b3b00fff9431785",
      "qrUrl": null,
      "number": "387c18c04b4f7979",
      "putTimeStr": "2020-03-11 15:30:08",
      "longitude": 117.14148919779346,
      "dimensionality": 33.282793584066,
      "state": 0
    },
    {
      "id": "926D9C2CBD624620BF906A5778F1CD46",
      "qrId": "171d751961c511eabee400fff9431785",
      "qrUrl": null,
      "number": "81bde30a0bd9469a",
      "putTimeStr": "2020-03-11 17:20:14",
      "longitude": 117.1524593232425,
      "dimensionality": 33.28380567317154,
      "state": 0
    },
    {
      "id": "C03AD29FEFC84652BAEFBFBE756CF8C6",
      "qrId": "04f3ae9d642c11ea8b3b00fff9431785",
      "qrUrl": null,
      "number": "1f239648b352941a",
      "putTimeStr": "2020-03-12 14:49:10",
      "longitude": 0,
      "dimensionality": 0,
      "state": 0
    }
  ]
};
List list = map["data"];
var abc = list[0]["longitude"];
print(abc);

}