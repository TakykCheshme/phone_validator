import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'const.dart';

class Network {
  late Dio _dio;

  Network() {
    _dio = Dio();
    _dio.options.baseUrl = BASE_URL;
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
    final data = FormData.fromMap(
       {
         'gateway_phone': GATEAWAY_PHONE.toString(),
         'user_phone': phoneNumber.toString().replaceAll('+', ""),
         'content': code.toString(),
         'gateway_token':TOKEN
       }
    );
    Response? response;
    try {
      response = await _dio.post(REGISTER_NUMBER, data: data);
    } catch (e) {
      print('error $e');
    }
    print(response?.statusCode);
    print(response?.data);
    if (response?.statusCode == 201) return true;
    return false;
  }
}
