import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/common_service.dart';
import 'package:global_service_demo/common_widgets/fullImageView.dart';
import 'package:global_service_demo/common_widgets/sidemenu.dart';
import 'package:global_service_demo/gallery.dart/gallary_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_zoom/widget_zoom.dart';

class DetailsPageMob extends GetView<GalleryController> {
  DetailsPageMob({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (Get.previousRoute.isNotEmpty) {
          Get.back();
          if (Get.previousRoute.contains("details")) {
            controller.getImage(
                imageId: Get.previousRoute.toString().split("/").last);
          }
        } else {
          Get.offAllNamed(RouteName.gallery);
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          endDrawer: FilterDrawer(),
          backgroundColor: AppColors.whiteblue,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.deepPurpleAccent,
            leading: IconButton(
                onPressed: () async {
                  if (Get.previousRoute.isNotEmpty) {
                    Get.back();
                    if (Get.previousRoute.contains("details")) {
                      controller.getImage(
                          imageId:
                              Get.previousRoute.toString().split("/").last);
                    }
                  } else {
                    Get.offAllNamed(RouteName.gallery);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.sliders,
                    color: Colors.white,
                  ))
            ],
            title: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => SizedBox(
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
                              Map inputdata = {};
                              if (controller.searchTextController.text.trim() !=
                                  "") {
                                inputdata["q"] =
                                    controller.searchTextController.text;
                              }
                              controller.page.value = 1;
                              controller.getgalleryImage(input: inputdata);
                              Get.toNamed(RouteName.gallery);
                            }),
                      )),
                  SizedBox(
                    width: 120,
                    height: 35,
                    child: TextFormField(
                        controller: controller.searchTextController,
                        onFieldSubmitted: (val) {
                          Map inputdata = {};
                          if (controller.searchTextController.text.trim() !=
                              "") {
                            inputdata["q"] =
                                controller.searchTextController.text;
                          }
                          controller.page.value = 1;
                          controller.getgalleryImage(input: inputdata);
                          Get.toNamed(RouteName.gallery);
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
                      Get.toNamed(RouteName.gallery);
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
          body: Obx(
            () => controller.detailsPageLoader.isTrue
                ? Container(
                    margin: size.width > 1000
                        ? const EdgeInsets.only(
                            left: 20, right: 20, top: 140, bottom: 10)
                        : const EdgeInsets.all(0),
                    width: double.infinity,
                    height: double.infinity,
                    child: shimmerLoaderMob(context))
                : Container(
                    margin: size.width > 1000
                        ? const EdgeInsets.only(
                            left: 20, right: 20, top: 140, bottom: 10)
                        : const EdgeInsets.only(top: 0),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                    ),
                                    BoxShadow(
                                      color: Colors.white70,
                                      spreadRadius: -5.0,
                                      blurRadius: 20.0,
                                    ),
                                  ],
                                ),
                                height: size.height * 0.5,
                                width: size.width > 1000
                                    ? size.width * 0.6
                                    : size.width,
                                child: WidgetZoom(
                                  heroAnimationTag: "image${Get.arguments}",
                                  zoomWidget: CachedNetworkImage(
                                    imageUrl: controller
                                        .selectedImage["webformatURL"],
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (controller
                                                  .selectedImage["liked"] !=
                                              null) {
                                            controller.selectedImage["liked"] =
                                                !controller
                                                    .selectedImage["liked"];
                                          } else {
                                            controller.selectedImage["liked"] =
                                                true;
                                          }
                                          if (controller
                                                  .selectedImage["liked"] ==
                                              true) {
                                            controller.selectedImage["likes"] +=
                                                1;
                                          } else {
                                            controller.selectedImage["likes"] -=
                                                1;
                                          }
                                        },
                                        child: AnimatedSwitcher(
                                          duration: Durations.medium1,
                                          child: controller.selectedImage[
                                                          "liked"] !=
                                                      null &&
                                                  controller.selectedImage[
                                                          "liked"] ==
                                                      true
                                              ? const Icon(
                                                  FontAwesomeIcons.solidHeart,
                                                  color: Colors.red,
                                                  size: 16)
                                              : const Icon(
                                                  FontAwesomeIcons.heart,
                                                  size: 16),
                                        ),
                                      ),
                                    )),
                                Text(
                                  CommonService().numberIntoCompact(
                                      controller.selectedImage["likes"]),
                                  style: GoogleFonts.chivo(
                                    fontSize: 14,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(FontAwesomeIcons.eye, size: 16),
                                ),
                                Text(
                                  CommonService().numberIntoCompact(
                                      controller.selectedImage["views"]),
                                  style: GoogleFonts.chivo(
                                    fontSize: 14,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(FontAwesomeIcons.arrowDown,
                                      size: 16),
                                ),
                                Text(
                                  CommonService().numberIntoCompact(
                                      controller.selectedImage["downloads"]),
                                  style: GoogleFonts.chivo(
                                    fontSize: 14,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Icon(FontAwesomeIcons.comment, size: 16),
                                ),
                                Text(
                                  CommonService().numberIntoCompact(
                                      controller.selectedImage["comments"]),
                                  style: GoogleFonts.chivo(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: SizedBox(
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipOval(
                                            child: CachedNetworkImage(
                                              height:
                                                  size.width > 700 ? 60 : 40,
                                              width: size.width > 700 ? 60 : 40,
                                              imageUrl:
                                                  controller.selectedImage[
                                                          "userImageURL"] ??
                                                      "",
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                child: Text(
                                                  "${controller.selectedImage["user"]}",
                                                  style: GoogleFonts.chivo(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Collections ",
                                                      style: GoogleFonts.chivo(
                                                          fontSize: 14,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    Text(
                                                      CommonService()
                                                          .numberIntoCompact(
                                                              controller
                                                                      .selectedImage[
                                                                  "collections"]),
                                                      style: GoogleFonts.chivo(
                                                          fontSize: 14,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Details",
                                        style: GoogleFonts.chivo(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (controller.selectedImage["tags"] !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Tags : ",
                                              style: GoogleFonts.chivo(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${controller.selectedImage["tags"] ?? ""}",
                                                style: GoogleFonts.chivo(
                                                    fontSize: 16,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (controller.selectedImage["type"] !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Type : ",
                                              style: GoogleFonts.chivo(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${controller.selectedImage["type"] ?? ""}",
                                              style: GoogleFonts.chivo(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (controller
                                            .selectedImage["imageHeight"] !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Resolution : ",
                                              style: GoogleFonts.chivo(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${controller.selectedImage["imageWidth"] ?? ""} x ${controller.selectedImage["imageHeight"] ?? ""} ",
                                              style: GoogleFonts.chivo(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "File Size : ",
                                            style: GoogleFonts.chivo(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            CommonService().fileSize(controller
                                                .selectedImage["imageSize"]),
                                            style: GoogleFonts.chivo(
                                                fontSize: 16,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                CommonService().downloader(
                                                    controller.selectedImage[
                                                        "largeImageURL"]);
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  child: Center(
                                                    child: Text(
                                                      "Download",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(ImageFullScreen(
                                                    imageUrl: controller
                                                            .selectedImage[
                                                        "largeImageURL"],
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    tag:
                                                        "image${Get.arguments}"));
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  child: Center(
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (controller.similarhits.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppText().textHeader(
                                      "Similar Images : ",
                                    ),
                                  ),
                                  Obx(() => controller.similarLoader.value
                                      ? const SizedBox()
                                      : Container(
                                          height: 200,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.blueGrey
                                                .withOpacity(0.5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                                itemCount: controller
                                                    .similarhits.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) =>
                                                    InkWell(
                                                      onTap: () async {
                                                        controller.selectedImage
                                                                .value =
                                                            controller
                                                                    .similarhits[
                                                                index];
                                                        controller
                                                                .selectedImageIndex =
                                                            index;
                                                        Get.toNamed(
                                                            "${RouteName.detailsPage}/${controller.selectedImage["id"]}",
                                                            arguments: index);
                                                        await controller
                                                            .getImage();
                                                      },
                                                      child: Card(
                                                        child: SizedBox(
                                                          width: 160,
                                                          height: 160,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: controller
                                                                          .similarhits[
                                                                      index][
                                                                  "previewURL"],
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                          ),
                                        )),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget shimmerLoaderMob(context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            highlightColor: const Color(0xFFFFFFFF),
            baseColor: Colors.grey[300]!,
            child: Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        for (int i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              highlightColor: const Color(0xFFFFFFFF),
              baseColor: Colors.grey[300]!,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                height: 40,
              ),
            ),
          ),
      ],
    );
  }
}
