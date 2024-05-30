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

  Future<List<LatLng>> getRouteData({required LatLng desintation}) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
        latitude: currentLocation!.latitude,
        longitude: currentLocation!.longitude,
      )),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
        latitude: desintation.latitude,
        longitude: desintation.longitude,
      )),
    );
    RoutesModel routes =
        await fetchRoutes(origin: origin, destination: destination);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, routes);
    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(List<LatLng> points,
      {required Set<Polyline> polyLines,
      required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 5,
      polylineId: const PolylineId('route'),
      points: points,
    );

    polyLines.add(route);

    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
  }

  Future<RoutesModel> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers}) async {
    String baseUrl =
        'https://routes.googleapis.com/directions/v2:computeRoutes';
    String apiKey = 'AIzaSyBg-P2_ewkLAdPCO830l9WiBarHbckwifI';
    Uri url = Uri.parse(baseUrl);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
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

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No routes found');
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    String baseUrl = 'AIzaSyBg-P2_ewkLAdPCO830l9WiBarHbckwifI';
    String apiKey = 'AIzaSyCBDnypXiwrEPnP_L6-by6QcJMW_Y8aOwI';
    var response = await http
        .get(Uri.parse('$baseUrl/details/json?key=$apiKey&place_id=$placeId'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];
      dev.log(
          PlaceDetailsModel.fromJson(data).geometry!.location!.lat.toString());
      dev.log(
          PlaceDetailsModel.fromJson(data).geometry!.location!.lng.toString());

      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }

  void updateCurrentLocation(
      {required GoogleMapController googleMapController,
      required Set<Marker> markers,
      required Function onUpdatecurrentLocation}) {
    locationService.getRealTimeLocationData((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      Marker currentLocationMarker = Marker(
        markerId: const MarkerId('my location'),
        position: currentLocation!,
      );
      CameraPosition myCurrentCameraPoistion = CameraPosition(
        target: currentLocation!,
        zoom: 17,
      );
      googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPoistion));
      markers.add(currentLocationMarker);
      onUpdatecurrentLocation();
    });
  }
/*
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }*/
}
