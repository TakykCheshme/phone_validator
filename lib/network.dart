import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:phone_validator/models/settings.dart';

class Network {
  late Dio _dio;

  Network(String baseUrl) {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.sendTimeout = 5000;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 5000;
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<bool> registerNumber(String? phoneNumber, String? code) async {
    var  settings = await Settings.getInstance();
    final data = FormData.fromMap(
       {
         'gateway_phone': settings.gateWayPhone.toString(),
         'user_phone': phoneNumber.toString().replaceAll('+', ""),
         'content': code.toString(),
         'gateway_token':settings.gateWayToken
       }
    );
    Response? response;
    try {
      response = await _dio.post(settings.smsPath, data: data);
    } catch (e) {
      print('error $e');
    }
    print(response?.statusCode);
    print(response?.data);
    if (response?.statusCode == 201) return true;
    return false;
  }
}
