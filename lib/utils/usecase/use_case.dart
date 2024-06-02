import 'package:dartz/dartz.dart';

import '../constant/app_failure.dart';

abstract class UseCase<Type, Param> {
  Future<Either<Failure, Type>> call([Param param]);
}

abstract class RoutesUseCase<Type, Origin, Destination> {
  Future<Either<Failure, Type>> call([Origin origin, Destination destination]);
}

class NoParam {}
