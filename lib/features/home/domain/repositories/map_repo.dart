import 'package:dartz/dartz.dart';

import '../../../../utils/constant/app_failure.dart';
import '../../data/models/location_info/location_info.dart';
import '../../data/models/place_details_model/place_details_model.dart';
import '../../data/models/routes_model/routes_model.dart';
import '../../data/models/routes_modifiers.dart';

abstract class MapRepo {
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId});
  Future<Either<Failure, RoutesModel>> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers});
}
