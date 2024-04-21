import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/routes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: PageRoutes.route,
      initialRoute: RouteName.gallery,
    );
  }
}
