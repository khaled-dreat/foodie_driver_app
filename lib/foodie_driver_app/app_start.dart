import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home/home_view.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}
