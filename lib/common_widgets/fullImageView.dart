import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageFullScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final VoidCallback onTap;

  ImageFullScreen(
      {required this.imageUrl, required this.onTap, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Full screen view",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              errorWidget: (context, url, error) => const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
