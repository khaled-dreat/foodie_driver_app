import 'dart:convert';
import 'dart:developer';

import 'package:foodie_driver_app/utils/service/api/api_key.dart';

import '../../../../utils/service/api/api_service.dart';
import '../../domain/entities/place_entity.dart';
import '../models/location_info/location_info.dart';
import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../models/place_details_model/place_details_model.dart';
import '../models/routes_model/routes_model.dart';
import '../models/routes_modifiers.dart';

abstract class MapRemoteDataSource {
  // * Fetch All Books
  //Future<List<PlaceEntity>> getPredictions(
  //    {required String input, required String sesstionToken});
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId});
  Future<RoutesModel> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers});
}

class MapRemoteDataSourceImpl extends MapRemoteDataSource {
  final ApiService apiService;

  MapRemoteDataSourceImpl({required this.apiService});
  @override
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await apiService.getPlaceDetails(placeId: placeId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.data)['result'];

      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }

  @override
  Future<RoutesModel> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers}) async {
    var response =
        await apiService.postRoutes(origin: origin, destination: destination);
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(response.data);
    } else {
      throw Exception('No routes found');
    }
  }
}
