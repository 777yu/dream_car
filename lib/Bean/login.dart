import 'text.dart';
import 'package:dio/dio.dart';
void login()async{
   Dio dio = new Dio();
   Response response = await dio.get("http://localhost:8080/login");
   print(response.data);
}