import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../features/home/data/models/location_info/location_info.dart';
import '../../../features/home/data/models/routes_modifiers.dart';
import 'api_key.dart';

class ApiService {
  final Dio _dio;

  final String placeBaseUrl = 'https://maps.googleapis.com/maps/api/place';
  String routesBaseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  final String apiKey = 'AIzaSyC87Tt3tfO6aYids0BZStXXbrdAy05jQCI';

  ApiService(this._dio);

  Future<Response> getPlaceDetails({required String placeId}) async {
    return await _dio.get(
        '$placeBaseUrl/details/json?key=${ApiKey.apiKeyRoutes}&place_id=$placeId');
  }

  Future<Response> postRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': ApiKey.apiKeyRoutes,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destination.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": routesModifiers != null
          ? routesModifiers.toJson()
          : RoutesModifiers().toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    var response = await _dio.post(
      routesBaseUrl,
      options: Options(
        headers: headers,
      ),
      data: body,
    );
    return response;
  }
}
