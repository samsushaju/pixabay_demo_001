import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/gallery.dart/gallary_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends GetView<GalleryController> {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() => size.width > 1000
        ? Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                height: controller.expandHeader.value ? 300 : 80,
                width: double.infinity,
                duration: Durations.extralong2,
                color: controller.expandHeader.value
                    ? Colors.transparent
                    : Colors.deepPurpleAccent,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: Durations.extralong2,
                  opacity: controller.expandHeader.value ? 1 : 0,
                  child: SvgPicture.asset(
                    "assets/blob-scene-haikei.svg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AnimatedPositioned(
                  top: controller.expandHeader.value ? 100 : 20,
                  duration: Durations.extralong2,
                  child: AnimatedOpacity(
                    duration: Durations.extralong2,
                    opacity: controller.expandHeader.value ? 1 : 0,
                    child: Text(
                      "Find Awesome images Here",
                      style: GoogleFonts.golosText(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              AnimatedPositioned(
                // left: 100,
                top: controller.expandHeader.value ? 150 : 20,
                duration: Durations.extralong2,
                child: SearchTabWeb(),
              ),
            ],
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                height: controller.expandHeader.value ? 300 : 60,
                width: double.infinity,
                duration: Durations.extralong2,
                color: controller.expandHeader.value
                    ? Colors.transparent
                    : Colors.deepPurpleAccent,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: Durations.extralong2,
                  opacity: controller.expandHeader.value ? 1 : 0,
                  child: SvgPicture.asset(
                    "assets/blob-scene-haikei.svg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AnimatedPositioned(
                  top: controller.expandHeader.value ? 100 : 5,
                  duration: Durations.extralong2,
                  child: AnimatedOpacity(
                    duration: Durations.extralong2,
                    opacity: controller.expandHeader.value ? 1 : 0,
                    child: Text(
                      "Find Awesome images Here",
                      style: GoogleFonts.golosText(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              AnimatedPositioned(
                  // left: 100,
                  top: controller.expandHeader.value ? 150 : 2,
                  duration: Durations.extralong2,
                  child: const SearchTab()),
              Positioned(
                top: 2,
                right: 5,
                child: Visibility(
                  visible: !controller.expandHeader.value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          controller.scaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.sliders,
                          color: Colors.white,
                        )),
                  ),
                ),
              )
            ],
          ));
  }
}

class SearchTabWeb extends GetView<GalleryController> {
  const SearchTabWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                ),
                const BoxShadow(
                  color: Colors.grey,
                  spreadRadius: -0.5,
                  blurRadius: 20.0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10, left: 16),
                          border: InputBorder.none),
                      value: controller.imageType.value,
                      items: const [
                        DropdownMenuItem(
                            value: "all",
                            child: Text(
                              "All images",
                            )),
                        DropdownMenuItem(
                            value: "vector",
                            child: Text(
                              "Vector",
                            )),
                        DropdownMenuItem(
                            value: "illustration",
                            child: Text(
                              "Illustration",
                            )),
                        DropdownMenuItem(
                          value: "Photo",
                          child: Text(
                            "photo",
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        controller.imageType.value = val.toString();
                        Map inputdata = {};
                        if (controller.searchTextController.text.trim() != "") {
                          inputdata["q"] = controller.searchTextController.text;
                        }
                        controller.page.value = 1;
                        controller.getgalleryImage(input: inputdata);
                        Get.toNamed(RouteName.gallery);
                      }),
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextFormField(
                      controller: controller.searchTextController,
                      onFieldSubmitted: (val) {
                        Map inputdata = {};
                        if (controller.searchTextController.text.trim() != "") {
                          inputdata["q"] = controller.searchTextController.text;
                        }
                        controller.page.value = 1;
                        controller.getgalleryImage(input: inputdata);
                      },
                      decoration: const InputDecoration(
                          hintText: "Search Images",
                          contentPadding: EdgeInsets.only(bottom: 12),
                          border: InputBorder.none)),
                ),
                InkWell(
                  onTap: () {
                    Map inputdata = {};
                    if (controller.searchTextController.text.trim() != "") {
                      inputdata["q"] = controller.searchTextController.text;
                    }
                    controller.page.value = 1;
                    controller.getgalleryImage(input: inputdata);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                ),
                const BoxShadow(
                  color: Colors.grey,
                  spreadRadius: -0.5,
                  blurRadius: 20.0,
                ),
              ],
            ),
            child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10, left: 16),
                    border: InputBorder.none),
                value: controller.orientation.value,
                items: const [
                  DropdownMenuItem(
                      value: "all",
                      child: Text(
                        "All",
                      )),
                  DropdownMenuItem(
                      value: "vertical",
                      child: Text(
                        "Portrait",
                      )),
                  DropdownMenuItem(
                      value: "horizontal",
                      child: Text(
                        "Landscape",
                      )),
                ],
                onChanged: (val) {
                  controller.orientation.value = val.toString();
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                ),
                const BoxShadow(
                  color: Colors.grey,
                  spreadRadius: -0.5,
                  blurRadius: 20.0,
                ),
              ],
            ),
            child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10, left: 16),
                    border: InputBorder.none),
                value: controller.sort.value,
                items: const [
                  //"popular", "latest"
                  DropdownMenuItem(
                      value: "popular",
                      child: Text(
                        "Popular",
                      )),
                  DropdownMenuItem(
                      value: "latest",
                      child: Text(
                        "Latest",
                      )),
                ],
                onChanged: (val) {
                  controller.sort.value = val.toString();
                }),
          ),
        ),
      ],
    );
  }
}

class SearchTab extends GetView<GalleryController> {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.menuLoader.value
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          const BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -0.5,
                            blurRadius: 20.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 35,
                            child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 10, left: 16),
                                    border: InputBorder.none),
                                value: controller.imageType.value,
                                items: const [
                                  DropdownMenuItem(
                                      value: "all",
                                      child: Text(
                                        "All images",
                                      )),
                                  DropdownMenuItem(
                                      value: "vector",
                                      child: Text(
                                        "Vector",
                                      )),
                                  DropdownMenuItem(
                                      value: "illustration",
                                      child: Text(
                                        "Illustration",
                                      )),
                                  DropdownMenuItem(
                                    value: "Photo",
                                    child: Text(
                                      "photo",
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  controller.imageType.value = val.toString();
                                }),
                          ),
                          SizedBox(
                            width: controller.expandHeader.value ? 120 : 100,
                            height: 35,
                            child: TextFormField(
                                controller: controller.searchTextController,
                                onFieldSubmitted: (val) {
                                  Map inputdata = {};
                                  if (controller.searchTextController.text
                                          .trim() !=
                                      "") {
                                    inputdata["q"] =
                                        controller.searchTextController.text;
                                  }
                                  controller.page.value = 1;
                                  controller.getgalleryImage(input: inputdata);
                                },
                                decoration: const InputDecoration(
                                    hintText: "Search Images",
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    border: InputBorder.none)),
                          ),
                          InkWell(
                            onTap: () {
                              Map inputdata = {};
                              if (controller.searchTextController.text.trim() !=
                                  "") {
                                inputdata["q"] =
                                    controller.searchTextController.text;
                              }
                              controller.page.value = 1;
                              controller.getgalleryImage(input: inputdata);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: controller.expandHeader.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          const BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -0.5,
                            blurRadius: 20.0,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 10, left: 16),
                              border: InputBorder.none),
                          value: controller.orientation.value,
                          items: const [
                            DropdownMenuItem(
                                value: "all",
                                child: Text(
                                  "All",
                                )),
                            DropdownMenuItem(
                                value: "vertical",
                                child: Text(
                                  "Portrait",
                                )),
                            DropdownMenuItem(
                                value: "horizontal",
                                child: Text(
                                  "Landscape",
                                )),
                          ],
                          onChanged: (val) {
                            controller.orientation.value = val.toString();
                          }),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          const BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -0.5,
                            blurRadius: 20.0,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 10, left: 16),
                              border: InputBorder.none),
                          value: controller.sort.value,
                          items: const [
                            //"popular", "latest"
                            DropdownMenuItem(
                                value: "popular",
                                child: Text(
                                  "Popular",
                                )),
                            DropdownMenuItem(
                                value: "latest",
                                child: Text(
                                  "Latest",
                                )),
                          ],
                          onChanged: (val) {
                            controller.sort.value = val.toString();
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ));
  }
}
