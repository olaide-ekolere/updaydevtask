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
the image search provider from Shutterstock to maybe unsplash
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
A full detailed article can be on environments can be found
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

### BLOC Pattern
We will be using the BLOC pattern architecture for this application.
We will like to separate Business Logic and other logical parts of
the application. BLOC will never have any reference of the Widgets
in the UI Screen. The UI screen will only observe changes coming
from BLOC class.

![The BLOC Pattern](https://miro.medium.com/max/1400/1*MqYPYKdNBiID0mZ-zyE-mA.png)
This pattern was choosen over the others because it was custom made for the
flutter framework and i find it amazing and easy to use due to its reactive
nature and adaptive UI.







