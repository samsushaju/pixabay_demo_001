import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/gallery.dart/gallary_controller.dart';

// ignore: must_be_immutable
class FilterDrawer extends GetView<GalleryController> {
  FilterDrawer({super.key});

  GlobalKey expanstionImage = GlobalKey();
  ExpansionTileController imageControl = ExpansionTileController();
  ExpansionTileController sortControl = ExpansionTileController();
  ExpansionTileController orientationControl = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Obx(
          () => controller.menuLoader.isTrue
              ? const SizedBox()
              : Column(
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          RotatedBox(
                              quarterTurns: 2,
                              child: SvgPicture.asset("assets/bottomcut.svg",
                                  color: Colors.deepPurpleAccent,
                                  fit: BoxFit.fill)),
                          const Positioned(
                              child: Icon(
                            FontAwesomeIcons.icons,
                            size: 50,
                            color: Colors.white,
                          ))
                        ],
                      ),
                    ),
                    ExpansionTile(
                        controller: imageControl,
                        title: Text(controller.imageController.text),
                        children: [
                          for (int i = 0; i < controller.allImage.length; i++)
                            ListTile(
                              onTap: () {
                                controller.menuLoader(true);
                                controller.imageController.text =
                                    controller.allImage[i]["name"];
                                imageControl.collapse();
                                controller.imageType.value =
                                    controller.allImage[i]["value"];
                                controller.menuLoader(false);
                              },
                              title: Text("${controller.allImage[i]["name"]}"),
                            ),
                        ]),
                    ExpansionTile(
                        controller: sortControl,
                        title: Text(controller.sortController.text),
                        children: [
                          for (int i = 0;
                              i < controller.sortSideMenu.length;
                              i++)
                            ListTile(
                              onTap: () {
                                controller.menuLoader(true);
                                controller.sortController.text =
                                    controller.sortSideMenu[i]["name"];
                                sortControl.collapse();
                                controller.sort.value =
                                    controller.sortSideMenu[i]["value"];
                                controller.menuLoader(false);
                              },
                              title:
                                  Text("${controller.sortSideMenu[i]["name"]}"),
                            ),
                        ]),
                    ExpansionTile(
                        controller: orientationControl,
                        title: Text(controller.orientationController.text),
                        children: [
                          for (int i = 0;
                              i < controller.orientationSideMenu.length;
                              i++)
                            ListTile(
                              onTap: () {
                                controller.menuLoader(true);
                                controller.orientationController.text =
                                    controller.orientationSideMenu[i]["name"];
                                orientationControl.collapse();
                                controller.orientation.value =
                                    controller.orientationSideMenu[i]["value"];
                                controller.menuLoader(false);
                              },
                              title: Text(
                                  "${controller.orientationSideMenu[i]["name"]}"),
                            ),
                        ]),
                  ],
                ),
        ));
  }
}
