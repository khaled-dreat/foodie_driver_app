import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/service/maps/location_service.dart';
import '../../data/models/location_info/lat_lng.dart';
import '../../data/models/location_info/location.dart';
import '../../data/models/location_info/location_info.dart';
import '../../data/models/routes_model/routes_model.dart';
import '../../domain/usecases/fetch_routes_use_case.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(this.fetchRoutesUseCase) : super(MapInitial());
  final FetchRoutesUseCase fetchRoutesUseCase;
  LocationService locationService = LocationService();
  LatLng? currentLocation;
  List<LatLng> points = [];
  Future<void> getRouteData() async {
    LatLng desintation = const LatLng(31.8840518, 35.4397575);

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
    var result = await fetchRoutesUseCase.call(
      origin,
      destination,
    );
    result.fold(
      (failure) {
        emit(MapFailure(errMessage: failure.message));
      },
      (routes) {
        PolylinePoints polylinePoints = PolylinePoints();
        points = getDecodedRoute(polylinePoints, routes);
      },
    );
  }

  void go(
      {required Set<Polyline> polyLines,
      required GoogleMapController googleMapController}) async {
    await getRouteData();
    displayRoute(
        polyLines: polyLines, googleMapController: googleMapController);
  }

  void displayRoute(
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

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
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
}
