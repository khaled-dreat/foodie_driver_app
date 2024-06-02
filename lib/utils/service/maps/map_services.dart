import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../features/home/data/models/location_info/lat_lng.dart';
import '../../../features/home/data/models/location_info/location.dart';
import '../../../features/home/data/models/location_info/location_info.dart';
import '../../../features/home/data/models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../../features/home/data/models/place_details_model/place_details_model.dart';
import '../../../features/home/data/models/routes_model/routes_model.dart';
import '../../../features/home/data/models/routes_modifiers.dart';
import 'google_maps_place_service.dart';
import 'location_service.dart';
import 'routes_service.dart';

class MapServices {
  // PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  // RoutesService routesService = RoutesService();
  LatLng? currentLocation;
  // Future<void> getPredictions(
  //     {required String input,
  //     required String sesstionToken,
  //     required List<PlaceModel> places}) async {
  //   if (input.isNotEmpty) {
  //     var result = await placesService.getPredictions(
  //         sesstionToken: sesstionToken, input: input);
//
  //     places.clear();
  //     places.addAll(result);
  //   } else {
  //     places.clear();
  //   }
  // }

/*
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }*/
}
