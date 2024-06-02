import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_driver_app/features/home/data/repositories/map_repo_empl.dart';
import 'package:foodie_driver_app/features/home/domain/usecases/fetch_routes_use_case.dart';
import 'package:foodie_driver_app/features/home/presentation/cubit/map_cubit.dart';
import 'package:foodie_driver_app/utils/setup_service_locator/setup_service_locator.dart';

import '../features/home/presentation/pages/home/home_view.dart';
import 'package:nested/nested.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}

List<SingleChildWidget> get providers {
  return [
    BlocProvider(
      create: (context) =>
          MapCubit(FetchRoutesUseCase(mapRepo: getIt.get<MapRepoEmpl>())),
    )
  ];
}
