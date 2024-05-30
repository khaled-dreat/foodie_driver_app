import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyC87Tt3tfO6aYids0BZStXXbrdAy05jQCI';

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    log(name: "Url", endPoint);
    var response = await _dio
        .get('  $baseUrl/autocomplete/json?key=$apiKey&input=تايجر لاند');

    return response.data;
  }
}
