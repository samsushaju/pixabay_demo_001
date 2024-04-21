import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_service_demo/app_constants.dart';
import 'package:global_service_demo/gallery.dart/galley_provider.dart';

class GalleryController extends GetxService {
  RxBool fullPageLoader = false.obs,
      similarLoader = false.obs,
      detailsPageLoader = false.obs,
      expandHeader = true.obs,
      upscrolling = false.obs;
  RxBool menuLoader = false.obs;

  RxInt columnsCount = 2.obs,
      page = 1.obs,
      skip = 50.obs,
      numofPage = 0.obs,
      from = 0.obs,
      to = 0.obs;
  RxDouble itemSize = 1.0.obs;
  RxList hits = [].obs, similarhits = [].obs;
  RxInt total = 0.obs, totalHits = 0.obs;
  RxMap selectedImage = {}.obs;
  dynamic selectedImageIndex;
  TextEditingController imageController = TextEditingController();
  TextEditingController sortController = TextEditingController();
  TextEditingController orientationController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController sliverscrollController = ScrollController();
  TextEditingController pageCountTextController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  RxString orientation = "all".obs;
  RxString imageType = "all".obs;
  RxString sort = "popular".obs;
  List chips = [
    "backgrounds",
    "fashion",
    "nature",
    "science",
    "education",
    "feelings",
    "health",
    "people",
    "religion",
    "places",
    "animals",
    "industry",
    "computer",
    "food",
    "sports",
    "transportation",
    "travel",
    "buildings",
    "business",
    "music"
  ];
  RxInt headerHeight = 250.obs;
  RxDouble pageOffset = 0.0.obs;

  List allImage = [
    {
      "name": "All images",
      "value": "all",
    },
    {
      "name": "Vector",
      "value": "vector",
    },
    {
      "name": "Illustration",
      "value": "illustration",
    },
    {
      "name": "Photo",
      "value": "photo",
    },
  ];

  List orientationSideMenu = [
    {
      "name": "All",
      "value": "all",
    },
    {
      "name": "Portrait",
      "value": "vertical",
    },
    {
      "name": "Landscape",
      "value": "horizontal",
    },
  ];
  List sortSideMenu = [
    {
      "name": "Popular",
      "value": "popular",
    },
    {
      "name": "Latest",
      "value": "latest",
    },
  ];

  @override
  void onInit() {
    if (Get.currentRoute.contains("details")) {
      getImage();
    } else {
      getgalleryImage();
    }
    textvalue();
    super.onInit();
  }

  getImage({String? imageId}) async {
    detailsPageLoader(true);
    var id = imageId ?? Get.parameters["id"];
    if (id != null && id != "") {
      Map inputData = {"page": page.value, "per_page": skip.value};
      inputData["id"] = id;
      var response = await GalleryProvider().imageApi(inputData);
      if (response["status"] != false) {
        var responsedata = response["data"];
        if (responsedata["hits"] != null && responsedata["hits"] != []) {
          List hits = responsedata["hits"] ?? [];
          if (hits.isNotEmpty) selectedImage.value = hits.first;
          await getSimilargalleryImage(
              inputValue: {"q": selectedImage["tags"]});
        }
      } else {
        Get.offAllNamed(RouteName.gallery);
      }
    } else {
      Get.offAllNamed(RouteName.gallery);
    }
    selectedImage.refresh();
    detailsPageLoader(false);
  }

  getgalleryImage({input}) async {
    fullPageLoader(true);
    Map inputData = {
      "page": page.value,
      "per_page": skip.value,
      "orientation": orientation.value,
      "image_type": imageType.value,
    };
    if (input != null && input != {}) {
      inputData.addAll(input);
    }
    var response = await GalleryProvider().imageApi(inputData);
    if (response["status"] != false) {
      var responseData = response["data"];
      hits.value = responseData["hits"] ?? [];
      total.value = responseData["total"] ?? 0;
      totalHits.value = responseData["totalHits"] ?? 0;
      hits.refresh();
      var numofData =
          hits.length >= totalHits.value ? hits.length : totalHits.value;
      numofPage.value = (numofData / skip.value).floor();
      from.value = (page.value - 1) * skip.value + 1;
      to.value = (page.value * skip.value);
      pageCountTextController.text = page.value.toString();
    } else {}
    fullPageLoader(false);
  }

  getSimilargalleryImage({inputValue}) async {
    similarLoader(true);
    Map inputData = {"page": page.value, "per_page": skip.value};
    if (inputValue != null) {
      inputData.addAll(inputValue);
    }
    var response = await GalleryProvider().imageApi(inputData);
    if (response["status"] != false) {
      var responseData = response["data"];
      similarhits.value = responseData["hits"] ?? [];
      similarhits.refresh();
    } else {}
    similarLoader(false);
  }

  // Calculate the size of each grid item based on the screen width
  double calculateItemSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Set a desired minimum item width (adjust as needed)
    double minItemWidth = screenWidth < 1000 ? 150.0 : 200;
    columnsCount.value = (screenWidth / minItemWidth).floor();
    itemSize.value = screenWidth / columnsCount.value;
    return itemSize.value;
  }

  textvalue() {
    var imageValue = allImage
        .firstWhereOrNull((element) => element["value"] == imageType.value);
    var orienteValue = orientationSideMenu
        .firstWhereOrNull((element) => element["value"] == orientation.value);
    var sortValue = sortSideMenu
        .firstWhereOrNull((element) => element["value"] == sort.value);
    imageController.text = imageValue["name"];
    orientationController.text = orienteValue["name"];
    sortController.text = sortValue["name"];
  }
}
