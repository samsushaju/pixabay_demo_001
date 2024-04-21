import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/details_page.dart/details_page.dart';
import 'package:global_service_demo/gallery.dart/gallary_controller.dart';
import 'package:global_service_demo/gallery.dart/gallary_page.dart';

class PageRoutes {
  static List<GetPage> route = [
    GetPage(
        name: RouteName.gallery,
        binding: BindingsBuilder.put(() => GalleryController()),
        page: () => const GalleryPage()),
    GetPage(
        name: "${RouteName.detailsPage}/:id",
        binding: BindingsBuilder.put(() => GalleryController()),
        page: () => const DetailsPageScreen()),
  ];
}
