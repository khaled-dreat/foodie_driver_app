import 'package:dartz/dartz.dart';
import 'package:foodie_driver_app/features/home/domain/repositories/map_repo.dart';

import '../../../../utils/constant/app_failure.dart';
import '../../../../utils/usecase/use_case.dart';
import '../../data/models/location_info/location_info.dart';
import '../../data/models/routes_model/routes_model.dart';

class FetchRoutesUseCase
    extends RoutesUseCase<RoutesModel, LocationInfoModel, LocationInfoModel> {
  final MapRepo mapRepo;

  FetchRoutesUseCase({required this.mapRepo});

  @override
  Future<Either<Failure, RoutesModel>> call(
      [LocationInfoModel? origin, LocationInfoModel? destination]) {
    return mapRepo.fetchRoutes(origin: origin!, destination: destination!);
  }
}
