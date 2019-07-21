# upday dev task

A flutter developer task for employment at upday

## Problem

Implement a hybrid app for android and ios that
fetches pictures from
the [Shutterstock API](http://api.shutterstock.com/) and display
them in an infinite scrollable view

## Solution

Create an hybrid app for android and iOS using the flutter framework
to implement the Shutterstock image search api\
![Shot 1][Shot1] &nbsp; ![Shot 2][Shot2] &nbsp; ![Shot 3][Shot3] &nbsp; ![Shot 4][Shot4]\
The Android APK can be downloaded
[here](https://webapp.diawi.com/install/nujZ36)

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
The _app/app_config.dart_  which is an
[InheritedWidget][inherited widget] holds
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
language. For now we will only be supporting English German and Spanish.

| English          | German           | Spanish          |
| ---------------- | ---------------- | ---------------- |
| ![Shot 1][English] | ![Shot 2][German] | ![Shot 3][Spanish] |

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
   * **Criteria 1**: Search Page Launched\
   Given the search page is initialized when the user navigates to it
    then the user should be instructed to start a search
   * **Criteria 2**: Typing search phrase\
   Given the search phrase is at least two
   characters when the user types then the search button should
   be enabled
   * **Criteria 3**: Initiate the images search\
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
requirements changes. Doing it this way allows us to mock the class for our test.
The abstract class forces each datasource to parse its
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
is injected into it. We will create an abstract _BlocBase_ class for all our BLOCs to
extend so we can enforce the dispose method to dispose a BLOC when no longer needed.
```
abstract class BlocBase{
  void dispose();
  void cancelOperation();
}
```
We also include a _cancelOperation_ method so currently running operations can be
cancelled.\
The image search screen will consist of two widgets, the _Image Search Widget_ and
_Image Search Results_ widget, so we will be creating a BLOC for each one.
The [ImageSearchPhraseBloc](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/bloc/image_search_phrase_bloc.dart)
will hold the different states of the ImageSearchWidget which is represented by an enum
```
enum SearchStatus { Initialized, Fetching, Error, Done }
```
Then the
[image_search_phrase_bloc_test.dart](https://github.com/olaide-ekolere/updaydevtask/blob/master/test/bloc/image_search_phrase_bloc_test.dart)
is written to check that all state changes are handled well.\
Next we create the
[ImageSearchResultBloc](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/bloc/image_search_result_bloc.dart)
 for receiving the results of
the first page and loading other subsequent pages.
[image_search_result_bloc_test.dart](https://github.com/olaide-ekolere/updaydevtask/blob/master/test/bloc/image_search_result_bloc_test.dart)
test is created test that it works as it is intended to.
### BLOC Provider
Using the BLOC pattern has given us the ability to
* Seperate Responsibilities
* Testability
* Freedom to organize our layout
* Reduction in the number of builds (because we will be using the
[StreamBuilder](https://www.youtube.com/watch?v=MkKEWHfy99Y)
in our widgets

The only thing left is the accessibility of the BLOC and we can do this in any of
following 3 ways
* Singleton\
This way is very possible but not really recommended. Also as there is no class
destructor in Dart, you will never be able to release the resources properly.
* Local Instance\
You may instantiate a local instance of a BLoC. Under some circumstances,
this solution perfectly fits some needs. In this case, you should always consider
initializing inside a StatefulWidget so that you can take profit of the dispose()
method to free it up.
* Ancestor\
The most common way of making it accessible is via an ancestor Widget, implemented
as a StatefulWidget. This is the approach we will be using.

So we will create the BlocProvider class for this purpose
```
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>>{
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}
```
With this we can simply instantiate a BlocProvider which will handle
a BLOC and will render a Widget along with it
```
BlocProvider<OurBloc>(
    bloc: OurBloc(),
    child: OurWidget(),
)
```
So we can easily retrieve the BLOC as shown below
```
Widget build(BuildContext context) {
    // TODO: implement build
    final OurBloc ourBloc =  BlocProvider.of<OurBloc>(context);
    return null;
}
 ```
We could have used an
[InheritedWidget][inherited widget] instead of a StatefulWidget but it
does not have a _dispose_ method as we plan to pair each BLOC with each
Widget and the would need to be disposed off when the widget no longer
exists

### Widgets
So our plan is to have 2 widgets on the ImageSearchPage, one to handle
the handle initiating the image search using the search phrase and another
to display the results and load more result pages.
* [ImageSearchPhraseWidget](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/widgets/image_search_phrase/image_search_phrase_widget.dart)\
This widget will accept the search phrase input by the user to initiate
the image search. This widget will also be responsible for satisfying
all the acceptance criteria of our first user story **(US_01)**.\
So we create
[image_search_phrase_widget_test.dart](https://github.com/olaide-ekolere/updaydevtask/tree/master/test/widgets/image_search_phrase)
to test that
  * Widget initializes correctly
  * User is informed to type search word
  * Search button is enabled when search can be initiated
  * The search phrase is provided to initiate the image search

It is good practise not to hardwire texts in the widgets so all our
text will be provided by localization that we have already
implemented which allows us to provide text for the different
languages we want to support. So to test our widgets we will need
to wrap it as shown below
```
var hint = "Type Search Phrase";
Widget wrapWidget(Widget widget) {
  return MaterialApp(
    localizationsDelegates: [
      AppTranslationsDelegate(
          newLocale: application.supportedLocales().first, testValues: """
          {"search_hint" : "$hint"}
          """),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: application.supportedLocales(),
    home: Scaffold(body: widget),
  );
}
```
and provide it with the texts the widget we are testing will be
expecting. We added the _Scaffold_ because the widget currently
being tested will require a Material ancestor since it doesnt
contain one.
* [ImageSearchResultsWidget](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/widgets/image_results/image_search_results_widget.dart)\
This widget will accept the first page of the image search result and
will load the next pages and the user scrolls to the bottom of the list.\
Firstly, we will create the
[ImageResultListItemWidget](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/widgets/image_results/image_result_list_item_widget.dart)
which will be responsible for displaying each
[ImageSearchItem](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/model/image_search_item.dart)
returned from the search. The
[cached_network_image](https://pub.dev/packages/cached_network_image)
plugin is used so we can provide a placeholder while the image loads and
also display an error is there is a problem with the image\
So we also create
[image_search_results_widget_test](https://github.com/olaide-ekolere/updaydevtask/blob/master/test/widgets/image_results/image_search_results_widget_test.dart)
to test that
  * Displays a no search message on start
  * Displays no search results message for no results
  * It initializes with the first page results
  * Load next page is fired when scrolled to the bottom

* [ImageSearchPage](https://github.com/olaide-ekolere/updaydevtask/blob/master/lib/page/image_search_page.dart)\
Both widgets above will be combined on this page. We will create
a new Object for this page which will hold references to the BLOCs
required for this page as shown below
```
import 'package:upday_dev_task/bloc/bloc.dart';

class ImageSearch {
  final ImageSearchPhraseBloc imageSearchPhraseBloc;
  final ImageSearchResultBloc imageSearchResultBloc;

  ImageSearch({this.imageSearchPhraseBloc, this.imageSearchResultBloc}) :
  assert(imageSearchPhraseBloc!=null),
  assert(imageSearchResultBloc!=null){
    imageSearchPhraseBloc.outImageSearchResult.listen(
      (imageSearchResult) =>
          imageSearchResultBloc.initWithImageSearchItems(imageSearchResult),
    );
  }
}
```
and then create a BLOC for this object. We set up the communication
between both BLOCs in the constructor so that the ImageSearchPhraseBloc
can pass the result of the first page to the ImageSearchResultBloc
This way the
BlocProvider can also be used as an ancestor for the
ImageSearchPage as shown below
```
BlocProvider(
    child: ImageSearchPage(),
    bloc: ImageSearchBloc(),
 );
```
So running the app shos the ImageSearchPage which contains both the
ImageSearchPhraseWidget for initiating a search and ImageSearchResultWidget
for displaying the results and loading more images. We use the
[NestedScrollView](https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html)
and [SliverAppBar](https://api.flutter.dev/flutter/material/SliverAppBar-class.html)
so we can hide/show the appbar as user scrolls. This caused this
[issue](https://github.com/flutter/flutter/issues/26409)
for our load more logic to fail because we use a
[ScrollController](https://api.flutter.dev/flutter/widgets/ScrollController-class.html)
to implement it. So the logic was moved to the itemBuilder function.

### Next Steps
So this is where we will stop now due to time constraints but here are the
things we would do next
* The TextField can be updated to an
[AutoCompleteTextField](https://pub.dev/packages/autocomplete_textfield)
so user can initiate previous search words. A
[SharedPreferences](https://pub.dev/packages/shared_preferences) would have
been used to store the keywords as against using a database which would seem
like an overkill for the task
* The UI can be improved on and Animations added
* Driver testers to perform integrated tests

I hope you have as much fun going through the project as i had building it.
### About Me
![Me](https://i.ibb.co/MDRY4D3/me.jpg)

I am
[Olaide Nojeem Ekeolere][resume]
, a hands-on, agile, learn-as-needed and highly competent software engineer
with more than 10 years' experience in software designing, programming
and testing software across a variety of platforms including all mobile
phone platforms (Android, iOS, Windows Phone, J2ME, Blackberry 10 and
Blackberry OS). I have worked on numerous projects including
self-started projects from concept to completion. A specialist in C#,
Java, Dart, Visual Basic.net, firebase and a little Objective C, ActionScript
and Kotlin, I take pride in coding to consistently high standards and
regularly refresh my skills to ensure I keep up with ongoing developments.
* [My Resume][resume]
* [LinkedIn][linkedin]

I am currently the Lead Mobile App developer at
[Wakanow](https://www.wakanow.com/en-ng/) managing
their flutter hybrid B2B and B2C apps.
###### Recent Apps
* Wakanow B2C
[Android](https://play.google.com/store/apps/details?id=com.wakanow.android)
[iOS](https://apps.apple.com/ng/app/wakanow-mobile/id1467891138)\
The official wakanow mobile app for booking flights, hotels, visas and get
holiday packages
* Wakanow B2B
[Android](https://play.google.com/store/apps/details?id=com.wakanow.affiliate)
[iOS](https://apps.apple.com/ng/app/wakanow-affiliates/id1469901513)\
The wakanow app that lets you partner with wakanow to help customers book
cheap flights and hotels.
* Mila
[Android](https://play.google.com/store/apps/details?id=com.vnigeria.milaapp)
[iOS](https://apps.apple.com/us/app/imila/id1437379934)\
iMila allows you to create events, invite attendees,
invite ushers, scan attendees in and allow them to
chat during the event.

Most of the projects i have worked on are hosted in private repositories
on Bitbucket and Azure Devops and would not be able to share but then
again i am always proud of my latest code too.





[Shot1]: https://i.ibb.co/smBLBFM/shot1.png
[SHot2]: https://i.ibb.co/2kQTbJ2/dhot2.png
[Shot3]: https://i.ibb.co/prF5srx/shot3.png
[Shot4]: https://i.ibb.co/98hJydT/shot4.png

[English]: https://i.ibb.co/K9NgvSH/english.png
[German]: https://i.ibb.co/pf5BGP7/german.png
[Spanish]: https://i.ibb.co/7CBSg6C/spanish.png
[resume]: https://www.scribd.com/document/419239420/EKEOLERE-OLAIDE-NOJEEM
[linkedin]: https://www.linkedin.com/in/olaide-ekeolere-92ba0a37/






[unsplash link]: https://unsplash.com/
[inherited widget]: https://www.youtube.com/watch?v=1t-8rBCGBYw