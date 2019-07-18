import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upday_dev_task/data/shutter_stock_data_provider.dart';

class MockClient extends Mock implements http.Client {}

class MockPreferences extends Mock implements SharedPreferences {}

const clientId = 'clientId';
const clientSecret = 'clientSecret';
const shutterstockData = '''
{
  "page": 1,
  "per_page": 1,
  "total_count": 193097419,
  "search_id": "p5S6QwRikdFJTHXwsoiqTg",
  "data": [
    {
      "id": "1120280123",
      "aspect": 1.6667,
      "assets": {
        "preview": {
          "height": 269,
          "url": "https://image.shutterstock.com/display_pic_with_logo/3673637/1120280123/stock-vector-minimal-geometric-background-dynamic-shapes-composition-eps-vector-1120280123.jpg",
          "width": 450
        },
        "small_thumb": {
          "height": 60,
          "url": "https://thumb10.shutterstock.com/thumb_small/3673637/1120280123/stock-vector-minimal-geometric-background-dynamic-shapes-composition-eps-vector-1120280123.jpg",
          "width": 100
        },
        "large_thumb": {
          "height": 90,
          "url": "https://thumb10.shutterstock.com/thumb_large/3673637/1120280123/stock-vector-minimal-geometric-background-dynamic-shapes-composition-eps-vector-1120280123.jpg",
          "width": 150
        },
        "huge_thumb": {
          "height": 260,
          "url": "https://image.shutterstock.com/image-vector/minimal-geometric-background-dynamic-shapes-260nw-1120280123.jpg",
          "width": 435
        }
      },
      "contributor": {
        "id": "3673637"
      },
      "description": "Minimal geometric background. Dynamic shapes composition. Eps10 vector.",
      "image_type": "vector",
      "media_type": "image",
      "url": "https://www.shutterstock.com/image-photo/1120280123"
    }
  ]
}
''';
var errorMessage = 'An error occurred';
main(){
  group('ShutterStockProviderTest', (){
    Map<String, String> header;
    MockClient client;
    MockPreferences preferences;
    ShutterStockDataProvider shutterStockDataProvider;
    
    setUp((){
      header = Map<String, String>();
      header['Content-Type'] = 'application/json';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
      header["Authorization"] = "Basic $basicAuth";
      client = MockClient();
      preferences = MockPreferences();
      shutterStockDataProvider = ShutterStockDataProvider(preferences, client, clientId: clientId, clientSecret: clientSecret);
    });

    tearDown((){
      client.close();
      //preferences.clear();
    });
    
    test('Fetches and parses data correctly for OK', () async{
      when(client.get(argThat(startsWith('http')), headers: header))
      .thenAnswer((_) async => http.Response(shutterstockData, 200));

      var result = await shutterStockDataProvider.getImageSearchResults('searchPhrase', 20, 1);
      expect(result.succeeded, true);
      expect(result.results.currentPage, 1);
    });


    test('Fetches and return error message if failed', () async{
      when(client.get(argThat(startsWith('http')), headers: header))
          .thenAnswer((_) async => http.Response(errorMessage, 400));

      var result = await shutterStockDataProvider.getImageSearchResults('searchPhrase', 20, 1);
      expect(result.succeeded, false);
      expect(result.message, errorMessage);
    });

  });
}