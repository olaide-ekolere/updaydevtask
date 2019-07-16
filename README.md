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
 without accidentally breaking anything for the production users.
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
arguments
_flutter build -t lib/shuttershock_development_
_flutter build -t lib/shuttershock_production_

_AndroidStudio_ allows us to
[create environment specific config](https://iirokrankka.com/2018/03/02/separating-build-environments#creating-environment-specific-run-configurations-in-intellij-idea--android-studio)
so we dont need to run via the command line.
A full detailed article can be on environments can be found
[here](https://iirokrankka.com/2018/03/02/separating-build-environments/)

###### Localization
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







