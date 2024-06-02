import 'package:dio/dio.dart';
import 'package:foodie_driver_app/features/home/data/datasources/map_remote_data_source.dart';
import 'package:foodie_driver_app/features/home/data/models/location_info/location_info.dart';
import 'package:foodie_driver_app/features/home/data/models/place_details_model/place_details_model.dart';
import 'package:foodie_driver_app/features/home/data/models/routes_model/routes_model.dart';
import 'package:foodie_driver_app/features/home/data/models/routes_modifiers.dart';
import 'package:foodie_driver_app/features/home/domain/repositories/map_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../utils/constant/app_failure.dart';

class MapRepoEmpl extends MapRepo {
  final MapRemoteDataSource mapRemoteDataSource;

  MapRepoEmpl(this.mapRemoteDataSource);

  @override
  Future<Either<Failure, RoutesModel>> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifiers? routesModifiers}) async {
    try {
      RoutesModel routesModel;
      routesModel = await mapRemoteDataSource.fetchRoutes(
          origin: origin, destination: destination);
      return right(routesModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) {
    // TODO: implement getPlaceDetails
    throw UnimplementedError();
  }
}
