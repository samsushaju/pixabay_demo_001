import 'dart:convert';
import 'package:http/http.dart' as http;

// gallery Provider handles the gallery api calls and data manipulation for Gallery View
class GalleryProvider {
  imageApi(inputData) async {
    var response = await ApiProvider().get(inputData);
    if (response != null) {
      return {"status": true, "message": "Completed", "data": response};
    } else {
      return {"status": false, "message": "SomeThing Went Wrong"};
    }
  }
}

// Api provider class to handle api calls
class ApiProvider {
  String rootUrl = "https://pixabay.com/api/",
      key = "43416730-90eac6564f2054b864b093286";

  get(Map data) async {
    String urlInput = "";
    urlInput += rootUrl;
    urlInput += "?key=$key";
    data.forEach((key, value) {
      if (key != null && key != "") {
        urlInput += "&$key=$value";
      }
    });
    Uri url = Uri.parse(urlInput);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodeData = jsonDecode(response.body);
      return decodeData;
    } else {
      return null;
    }
  }
}
