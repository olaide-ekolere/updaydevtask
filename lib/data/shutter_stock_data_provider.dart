import 'dart:convert';

import 'package:async/async.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/image_search_operation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShutterStockDataProvider extends ImageSearchDataProvider {
  final SharedPreferences preferences;
  final http.Client client;
  final String clientId;
  final String clientSecret;

  ShutterStockDataProvider(
    this.preferences,
    this.client, {
    this.clientId,
    this.clientSecret,
  })  : assert(preferences != null),
        assert(client != null),
        assert(clientId != null),
        assert(clientSecret != null);

  @override
  Future<ImageSearchOperation> getImageSearchResults(
    String searchPhrase,
    int pageCount,
    int page,
  ) async {
    var url =
        'https://api.shutterstock.com/v2/images/search?query=$searchPhrase&per_page=$pageCount&page=$page';
    var header = Map<String, String>();
    header['Content-Type'] = 'application/json';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
    header["Authorization"] = "Basic $basicAuth";
    var response = await client
        .get(url, headers: header)
        .timeout(Duration(minutes: 2), onTimeout: () async {
      return http.Response('Connection Timed out. Please try again', 408);
    });

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      int countPerPage = responseJson['per_page'];
      int totalRecords = responseJson['total_count'];
      int totalNumberPages = 1;
      if (totalRecords > countPerPage) {
        totalNumberPages = totalRecords ~/ countPerPage;
        if (totalRecords % countPerPage > 0) totalNumberPages += 1;
      }
      var imageSearchItems = List.from(responseJson['data'])
          .map((imageSearchMap) => getImageSearchItemFromJson(
              Map<String, dynamic>.from(imageSearchMap)))
          .toList();
      return ImageSearchOperation(
        response.statusCode,
        ImageSearchResult.initWithImageSearchItems(imageSearchItems,
            searchPhrase: searchPhrase,
            countPerPage: countPerPage,
            totalNumberPages: totalNumberPages,
            currentPage: page),
      );
    } else {
      return ImageSearchOperation(response.statusCode, response.body);
    }
  }

  @override
  ImageSearchItem getImageSearchItemFromJson(Map<String, dynamic> json) {
    // TODO: implement getImageSearchItemFromJson
    var assets = Map<String, dynamic>.from(json['assets']);
    var preview = Map<String, dynamic>.from(assets['preview']);
    return ImageSearchItem(
      url: preview['url'],
      width: preview['width'],
      height: preview['height'],
      description: json['description'],
    );
  }
}
