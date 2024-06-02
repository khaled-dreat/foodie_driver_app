part of 'map_cubit.dart';

sealed class MapState {
  const MapState();
}

final class MapInitial extends MapState {}

final class MapSuccess extends MapState {
  final RoutesModel routesModel;

  MapSuccess({required this.routesModel});
}

final class MapLoading extends MapState {}

final class MapFailure extends MapState {
  final String errMessage;

  MapFailure({required this.errMessage});
}
