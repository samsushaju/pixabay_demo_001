import 'package:flutter/material.dart';
import 'package:global_service_demo/details_page.dart/mob_details_page.dart';
import 'package:global_service_demo/details_page.dart/web_details_page.dart';

class DetailsPageScreen extends StatelessWidget {
  const DetailsPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, constraints) {
      if (constraints.maxWidth < 1000) {
        return DetailsPageMob();
      } else {
        return const DetailsPage();
      }
    });
  }
}
