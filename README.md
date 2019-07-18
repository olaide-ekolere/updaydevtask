# upday dev task

A flutter developer task for employment at upday

## Problem

Implement a hybrid app for android and ios that
fetches pictures from
the [Shutterstock API](http://api.shutterstock.com/) and display
them in an infinite scrollable view

## Solution

Create an hybrid app for android and iOS using the flutter framework
to implement the Shutterstock image search api

**_Observation after cloning repo:_** The first thing you will
notice is that 'main.dart' file which is the normal entry point of
every flutter app is missing. We will soon get to why it is missing
in the [Environment]() section below

### Environment
When developing mobile apps professionally,
we’ll need to have at least two different environments:
a development and a production one. This way we can develop
and test new features in the development backend,
 without accidentally breaking anything for the production users.\
For example the development environment can use a different
clientID and clientSecret from the one in production. This will
also be very useful when requirements change that we do not
want to break our tests. For example if the we decide to change
the image search provider from Shutterstock to maybe [Unsplash][unsplash link]
or any other image search provider. We will show how this is done
in the [Whatever]() section.
###### Configuration Object
The _app/app_config.dart_  which is an InheritedWidget holds
all the environment-dependent information which will take our
_MaterialApp_ instance as its child.
###### Entry point files
Flutter allows us to specify another file other than the _main.dart_
as the entry point of the app by specifying it in the build
arguments\
_flutter build -t lib/shuttershock_development_\
_flutter build -t lib/shuttershock_production_

_AndroidStudio_ allows us to
[create environment specific config](https://iirokrankka.com/2018/03/02/separating-build-environments#creating-environment-specific-run-configurations-in-intellij-idea--android-studio)
so we dont need to run via the command line.
A full detailed article on environments can be found
[here](https://iirokrankka.com/2018/03/02/separating-build-environments/)

### Localization
To reach a larger audience an app will need to be available in
different languages. We’re going to use the package
flutter_localizations that is based on Dart intl
package and it supports until now about
[24 languages](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations/lib/src/l10n).
Full details on how to implement app localization can be found
at this [link](https://proandroiddev.com/flutter-localization-step-by-step-30f95d06018d).
Unlike the link we will be storing our own language specific text in
a json text files located in the _assets/locale_ folder for each supported
language. For now we will only be supporting English and Spanish.

### User Stories
For this task we have come up with 2 user stories
* **US_01**: As a user, i can type a search phrase so that
 i can search available images
* **US_02**: As a user, i can view all the images that match my
search phrase
### Acceptance Criteria
To make the user stories testable we define the acceptance criteria
for each one
* **US_01**: As a user, i can type a search phrase so that
 i can search available images
   * **Criteria 1**: Typing search phrase\
   Given the search phrase is at least two
   characters when the user types then the search button should
   be enabled
   * **Criteria 2**: Initiate the images search\
   Given the user taps on the search button
   when it is enabled then the paginated image search should start
* **US_02**: As a user, i can view all the images that match my
search phrase
  * **Criteria 1**: No Images found\
  Given that there are no image results matching
  the search phrase when the results are available then the user
  should be shown a no results display
  * **Criteria 2**: Show Page 1 of Image Search Results\
  Given that images are available when the results are available
  then the first page of the image search results should be shown
  * **Criteria 3**: Load Next Pages\
  Given that the user has scrolled to the bottom when more pages are
  available

### Testing
[Unit](https://flutter.dev/docs/cookbook/testing/unit/introduction),
[widget](https://flutter.dev/docs/cookbook/testing/widget/introduction)
 and
 [integrated](https://flutter.dev/docs/testing#integration-tests)
 tests will be created to test all the
acceptance criteria. We will be using the flutter
[Mockito](https://pub.dev/packages/mockito)
to [mock](https://flutter.dev/docs/cookbook/testing/unit/mocking)
 data for our tests

### Models
First we create the ImageSearchItem object which will represent each image search result
returned in our second user story **(US_02)**.
```
class ImageSearchItem {
  final String url;
  final String description;

  ImageSearchItem(
    this.url,
    this.description,
  )   : assert(url != null),
        assert(description != null);
}
```
Then we create the ImageSearchResult object which will be responsible for hold all
necessary information about a completed image search.
```
import 'package:upday_dev_task/model/image_search_item.dart';

class ImageSearchResult {
  final String searchPhrase;
  final int countPerPage;
  final int totalNumberPages;

  List<ImageSearchItem> _imageSearchItems = [];
  int _currentPage;

  ImageSearchResult.initWithImageSearchItems(
    this.searchPhrase,
    this.countPerPage,
    this.totalNumberPages,
    List<ImageSearchItem> imageSearchItems, {
    int currentPage = 1,
  })  : assert(searchPhrase != null),
        assert(countPerPage != null),
        assert(imageSearchItems != null) {
    this._currentPage = currentPage;
    _imageSearchItems.addAll(imageSearchItems);
  }

  addNextPage(
    List<ImageSearchItem> imageSearchItems,
  ) {
    assert((_currentPage == (totalNumberPages - 1)) ||
        (_currentPage != (totalNumberPages - 1) &&
        imageSearchItems.length == countPerPage));
    _currentPage += 1;
  }

  bool get isEmpty => _imageSearchItems.length == 0;

  int get currentPage => _currentPage;

  List<ImageSearchItem> get imageSearchItems => _imageSearchItems;

  bool get canLoadMore => currentPage != totalNumberPages;
}
```
This class contains all the logic required to handle the result a successful image search
operation. It will handle the paging and loading more logic.
[image_search_result_test.dart](https://github.com/olaide-ekolere/updaydevtask/blob/master/test/model/image_search_result_test.dart)
, unit
test class is created to test that the class handles all the logic correctly.

### Data
We will create an abstract class called _ImageSearchDataProvider_ that will handle
fetching of the results from the API in our second user story **(US_02)**.
```
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/image_search_operation.dart';

abstract class ImageSearchDataProvider{
  Future<ImageSearchOperation> getImageSearchResults(String searchPhrase, int pageCount, int page);
  ImageSearchItem getImageSearchItemFromJson(Map<String, dynamic> json);
}
```
Using an abstract class allows us to change the datasource just incase the
requirements changes. The abstract class forces each datasource to parse its
own ImageSearchObject since they all wont have the same data structure.
 The Shutterstock datasource with extend this class and
provide its own implementation.
```
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

  @override
  ImageSearchItem getImageSearchItemFromJson(Map<String, dynamic> json) {
    // TODO: implement getImageSearchItemFromJson
    return null;
  }
}
```
if the requirement changes later to another datasource like maybe
[Unsplash][unsplash link] instead of Shutterstock, a new implementation
of ImageSearchDataProvider will be provided without breaking anything.\
Our assumption is that each environment will use a different datasource so our
AppConfig class will contain the datasource.\
The implementations for the methods are provided so that
[shutter_stock_data_provider_test.dart](https://github.com/olaide-ekolere/updaydevtask/blob/master/test/data/shutter_stock_data_provider_test.dart)
test is written to test the ShutterStock datasource.
```
import 'package:flutter/material.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';

class AppConfig extends InheritedWidget {
  final ImageSearchDataProvider imageSearchDataProvider;

  AppConfig({
    this.imageSearchDataProvider,
    Widget child,
  }) : super(child: child);

  static AppConfig of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppConfig);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
```
So our entry point main files will now look like this
```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upday_dev_task/app/app.dart';
import 'package:upday_dev_task/app/app_config.dart';
import 'package:upday_dev_task/data/shutter_stock_data_provider.dart';

void main() async {
  var preferences = await SharedPreferences.getInstance();
  var client = http.Client();
  var configuredApp = AppConfig(
    imageSearchDataProvider: ShutterStockDataProvider(
      preferences,
      client,
      clientId: 'd0c6b-c141e-00f1e-7067a-f1440-c2ecc',
      clientSecret: '89028-7b04b-07ed8-f051b-01af2-43cf1',
    ),
    child: UpdayTaskApp(preferences, client),
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(configuredApp));
  //runApp(UpdayTaskApp(preferences, client));
}
```



### BLOC Pattern
We will be using the BLOC pattern architecture for this application.
We will like to separate Business Logic and other logical parts of
the application. BLOC will never have any reference of the Widgets
in the UI Screen. The UI screen will only observe changes coming
from BLOC class.

![The BLOC Pattern](https://miro.medium.com/max/1400/1*MqYPYKdNBiID0mZ-zyE-mA.png)
This pattern was choosen over the others because it was custom made for the
flutter framework and i find it amazing and easy to use due to its reactive
nature and adaptive UI.\
We will use the [RxDart](https://pub.dartlang.org/packages/rxdart) package along with
the BLOC pattern. The RxDart package is an implementation for Dart of the
[ReactiveX](http://reactivex.io/) API,
which extends the original Dart Streams API to comply with the ReactiveX standards.\
So now we create the BLOC component to hold the _ImageSearchResult_ object. It will
also have an _ImageSearchDataProvider_ object to fetch data from whatever datasource
is injected into it. We will create an abstract _BlocBase_ class for our BLOC to
extend so we can enforce the dispose method to dispose a BLOC when no longer needed.
```
abstract class BlocBase{
  void dispose();
}
```











[unsplash link]: https://unsplash.com/