import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'dart:html' as html;

class CommonService {
  // change long numbers into compact short num like 1k instead of 1000
  numberIntoCompact(number) {
    if (GetUtils.isNumericOnly(number.toString())) {
      var formater = NumberFormat.compact(locale: 'en_US');
      return formater.format(int.parse(number.toString())).toString();
    } else {
      return "";
    }
  }

  // download image from url
  downloader(inputUrl) async {
    final response = await http.get(Uri.parse(inputUrl));
    var fileName = inputUrl.toString().split("/").last;
    final bytes = response.bodyBytes;

    if (GetPlatform.isWeb) {
      //// only for web download
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url);
      anchor.download = fileName;
      anchor.click();
      html.Url.revokeObjectUrl(url);
    } else {
      // for mob
      // Get temporary directory
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      final dir = await getTemporaryDirectory();
      var filename = '${dir.path}/SaveImage$fileName.png';
      final file = io.File(filename);
      await file.writeAsBytes(bytes);
      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      await FlutterFileDialog.saveFile(params: params);
    }
  }

  // bytes to mb,kb,gp Convertor
  fileSize(size) {
    const int bytesInKB = 1024;
    const int bytesInMB = bytesInKB * 1024;
    const int bytesInGB = bytesInMB * 1024;
    if (size >= bytesInGB) {
      double fileSizeInGB = size / bytesInGB;
      return "${fileSizeInGB.toStringAsFixed(2)} GB";
    } else if (size >= bytesInMB) {
      double fileSizeInMB = size / bytesInMB;
      return "${fileSizeInMB.toStringAsFixed(2)} MB";
    } else if (size >= bytesInKB) {
      double fileSizeInKB = size / bytesInKB;
      return "${fileSizeInKB.toStringAsFixed(2)} KB";
    } else {
      return "$size bytes";
    }
  }
}

enum StoreType { int, bool, double, string, list }

class LocalStorage {
  // Obtain shared preferences.
  store({required type, required key, value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case StoreType.int:
        // Save an integer value to 'counter' key.
        await prefs.setInt(key, value);
        break;
      case StoreType.bool:
        // Save an boolean value to 'repeat' key.
        await prefs.setBool(key, value);
        break;
      case StoreType.string:
        // Save an String value to 'action' key.
        await prefs.setString(key, value);
        break;
      case StoreType.double:
        // Save an double value to 'decimal' key.
        await prefs.setDouble(key, value);
        break;
      case StoreType.list:
        // Save an list of strings to 'items' key.
        await prefs.setStringList(key, value);
        break;
      default:
    }
  }

  // Obtain shared preferences.
  read({required type, required key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case StoreType.int:
        // Save an integer value to 'counter' key.
        return prefs.getInt(key);

      case StoreType.bool:
        // Save an boolean value to 'repeat' key.
        return prefs.getBool(key);

      case StoreType.string:
        // Save an String value to 'action' key.
        return prefs.getString(key);

      case StoreType.double:
        // Save an double value to 'decimal' key.
        return prefs.getDouble(key);
      case StoreType.list:
        // Save an list of strings to 'items' key.
        return prefs.getStringList(key);
      default:
    }
  }

  remove(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove data for the 'counter' key.
    await prefs.remove(key);
  }
}
