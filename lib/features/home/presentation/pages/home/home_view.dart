import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_driver_app/features/home/presentation/cubit/map_cubit.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/service/maps/map_services.dart';
import '../../../data/models/location_info/location_info.dart';
import '../../../data/models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../../data/models/place_details_model/place_details_model.dart';
import '../../../data/models/routes_model/routes_model.dart';
import '../../../data/models/routes_modifiers.dart';

class HomeView extends StatelessWidget {
  static const String nameRoute = "HomeView";
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeViewBody(),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late MapServices mapServices;
  late CameraPosition initalCameraPoistion;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  late Uuid uuid;
  Set<Polyline> polyLines = {};

  @override
  void initState() {
    super.initState();
    uuid = const Uuid();
    mapServices = MapServices();
    initalCameraPoistion = const CameraPosition(target: LatLng(0, 0));
  }

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = BlocProvider.of<MapCubit>(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GoogleMap(
            polylines: polyLines,
            markers: markers,
            mapType: MapType.terrain,
            onMapCreated: (controller) {
              googleMapController = controller;
              mapCubit.updateCurrentLocation(
                  googleMapController: googleMapController,
                  markers: markers,
                  onUpdatecurrentLocation: () => setState(() {}));
            },
            initialCameraPosition: initalCameraPoistion),
        ElevatedButton(
            onPressed: () async {
              mapCubit.go(
                  polyLines: polyLines,
                  googleMapController: googleMapController);
              setState(() {});
              //       getPlaceDetails(placeId: "ChIJRaWfSWzNHBURaTNEayYEkcM");
            },
            child: Text("Accept")),
      ],
    );
  }
}
// تايجر لاند
// [log] 31.8840518
// [log] 35.4397575