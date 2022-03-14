import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'http://localhost:4000',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);


Dio dio = Dio(options);