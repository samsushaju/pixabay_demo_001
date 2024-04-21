import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/common_service.dart';
import 'package:global_service_demo/common_widgets/header.dart';
import 'package:global_service_demo/gallery.dart/gallary_controller.dart';
import 'package:global_service_demo/common_widgets/sidemenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class GalleryPage extends GetView<GalleryController> {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.calculateItemSize(context);
    final size = MediaQuery.of(context).size;
    ScrollController scrollController = ScrollController();

    onscroll() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // User is scrolling down
        controller.upscrolling(true);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // User is scrolling up
        controller.upscrolling(false);
      }
      controller.pageOffset.value = scrollController.offset;
      if (controller.pageOffset > 200) {
        controller.expandHeader.value = false;
      } else {
        controller.expandHeader.value = true;
      }
    }

    return SafeArea(
      child: Scaffold(
        key: controller.scaffoldKey,
        endDrawer: FilterDrawer(),
        backgroundColor: AppColors.whiteblue,
        bottomNavigationBar: Obx(() => AnimatedContainer(
              height: controller.upscrolling.isTrue ? 60 : 0,
              color: AppColors.whiteblue,
              duration: Durations.medium1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${controller.from} - ${controller.to} of ${controller.totalHits} photos",
                        style: GoogleFonts.chivo(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Go to previous
                    IconButton(
                      disabledColor: Colors.black.withOpacity(0.3),
                      onPressed: controller.page.value == 1
                          ? null
                          : () {
                              controller.page.value -= 1;
                              Map inputdata = {};
                              if (controller.searchTextController.text.trim() !=
                                  "") {
                                inputdata["q"] =
                                    controller.searchTextController.text;
                              }
                              controller.getgalleryImage(input: inputdata);
                            },
                      icon: const Icon(Icons.keyboard_arrow_left),
                    ),
                    //
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: Form(
                        key: controller.formKey,
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              } else if (int.parse(value) >
                                  controller.numofPage.value) {
                                return "";
                              } else if (int.parse(value) == 0) {
                                return "";
                              } else {
                                return null;
                              }
                            },
                            onFieldSubmitted: (val) {
                              if (controller.formKey.currentState!.validate()) {
                                controller.formKey.currentState!.save();
                                Map inputdata = {};
                                if (controller.searchTextController.text
                                        .trim() !=
                                    "") {
                                  inputdata["q"] =
                                      controller.searchTextController.text;
                                }
                                controller.page.value =
                                    int.parse(val.toString());
                                controller.getgalleryImage(input: inputdata);
                              }
                            },
                            controller: controller.pageCountTextController,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                  height: 0,
                                ),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                contentPadding: const EdgeInsets.all(6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ))),
                      ),
                    ),
                    Text(" / ${controller.numofPage}"),
                    // Go to Next
                    IconButton(
                      onPressed: controller.numofPage.value ==
                              controller.page.value
                          ? null
                          : () {
                              controller.page.value += 1;
                              Map inputdata = {};
                              if (controller.searchTextController.text.trim() !=
                                  "") {
                                inputdata["q"] =
                                    controller.searchTextController.text;
                              }
                              controller.getgalleryImage(input: inputdata);
                            },
                      icon: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            )),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20.0,
                  ),
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.0,
                  ),
                ]),
                child: const Header()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.chips.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              controller.page.value += 1;
                              Map inputdata = {};
                              controller.searchTextController.text =
                                  controller.chips[index];
                              if (controller.searchTextController.text.trim() !=
                                  "") {
                                inputdata["q"] =
                                    controller.searchTextController.text;
                              }
                              controller.getgalleryImage(input: inputdata);
                            },
                            child: Chip(
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.search,
                                    size: 14,
                                  ),
                                ),
                                label: Text("${controller.chips[index]}")),
                          ),
                        )),
              ),
            ),
            Obx(() => controller.fullPageLoader.value
                ? SizedBox(height: size.height, child: shimmerBox())
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      onscroll();
                      return true;
                    },
                    child: Expanded(
                      child: SizedBox(
                        child: controller.hits.isEmpty
                            ? SizedBox(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://www.freepik.com/free-vector/hand-drawn-no-data-illustration_59563768.htm#fromView=search&page=1&position=29&uuid=1439c85f-4624-46f3-a38d-47f2a7eb6c4a",
                                  errorWidget: (context, url, error) {
                                    return const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.question,
                                          size: 50,
                                        ),
                                        Text(
                                          " Oops! No results found.\nPlease try another search.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : GridView.builder(
                                controller: scrollController,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: controller.columnsCount.value,
                                ),
                                itemCount: controller.hits.length,
                                itemBuilder: (context, index) => Card(
                                      child: InkWell(
                                        onTap: () async {
                                          controller.selectedImage.value =
                                              controller.hits[index];
                                          controller.selectedImageIndex = index;
                                          Map input = {};
                                          input["q"] =
                                              controller.selectedImage["tags"];
                                          controller.getSimilargalleryImage(
                                              inputValue: input);
                                          Get.toNamed(
                                              "${RouteName.detailsPage}/${controller.selectedImage["id"]}",
                                              arguments: index);
                                        },
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Hero(
                                              tag: "image$index",
                                              child: SizedBox(
                                                  height:
                                                      controller.itemSize.value,
                                                  width:
                                                      controller.itemSize.value,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${controller.hits[index]["webformatURL"]}",
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  )),
                                            ),

                                            Positioned(
                                              bottom: 5,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        FontAwesomeIcons.heart,
                                                        size: 16,
                                                           color: AppColors.whiteblue),
                                                    Text(
                                                      CommonService()
                                                          .numberIntoCompact(
                                                              controller
                                                                      .hits[index]
                                                                  ["likes"]),
                                                      style: GoogleFonts.chivo(
                                                        fontSize: 14,
                                                        color: AppColors.whiteblue
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                          FontAwesomeIcons.eye,
                                                          size: 16,   color: AppColors.whiteblue),
                                                    ),
                                                    Text(
                                                      CommonService()
                                                          .numberIntoCompact(
                                                              controller
                                                                      .hits[index]
                                                                  ["views"]),
                                                      style: GoogleFonts.chivo(
                                                        fontSize: 14,
                                                           color: AppColors.whiteblue
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget shimmerBox() {
    return GridView.builder(
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.columnsCount.value,
        ),
        itemBuilder: (context, index) => Shimmer.fromColors(
              highlightColor: const Color(0xFFFFFFFF),
              baseColor: Colors.grey[300]!,
              period: Durations.medium2,
              loop: 100,
              child: Card(
                child: SizedBox(
                  height: controller.itemSize.value,
                  width: controller.itemSize.value,
                ),
              ),
            ));
  }
}
