import 'package:upday_dev_task/data/image_search_data_provider.dart';
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
  });

  @override
  Future<ImageSearchOperation> getImageSearchResults(
      String searchPhrase, int pageCount, int page) {
    // TODO: implement getImageSearchResults
    return null;
  }
}
