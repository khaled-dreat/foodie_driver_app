import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:foodie_driver_app/utils/setup_service_locator/setup_service_locator.dart';

import 'foodie_driver_app/app_start.dart';
import 'utils/simple_bloc_observer/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  setupServiceLocatorApiService();
  setupServiceLocatorMap();
  runApp(const AppStart());
}
