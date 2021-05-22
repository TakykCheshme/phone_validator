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
  }

  Future<bool> registerNumber(String? phoneNumber, String? code) async {
    print('start registerNumber...');
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final data = FormData.fromMap({
      'point_id': POINT_ID,
      'point_phone': POINT_NUMBER,
      'phone': phoneNumber,
      'message': code,
      'date_incoming': timestamp,
      // 'test': 1,
    });
    final response = await _dio.post(REGISTER_NUMBER, data: data);
    print(response.data);
    print(response.statusCode);
    if (response.data['message'] != null &&
        response.data['message'] == 'Register is successfully') return true;
    return false;
  }
}
