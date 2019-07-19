import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/localization/application.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/image_search_phrase.dart';

class MockImageSearchDataProvider extends Mock
    implements ImageSearchDataProvider {}

var hint = "Type Search Phrase";
var testPhrase = "test";
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

void main() {
  group('ImageSearchPhraseWidget', () {
    MockImageSearchDataProvider mockImageSearchDataProvider;
    InitiateSearchObserver initiateSearchObserver;
    String searchPhrase;
    setUp(() {
      mockImageSearchDataProvider = MockImageSearchDataProvider();
      searchPhrase = null;
      initiateSearchObserver = (newSearchPhrase)=>searchPhrase = newSearchPhrase;
    });


    testWidgets('Search Hint displayed and Search Button disabled at launch',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          BlocProvider(
            child: ImageSearchPhraseWidget(),
            bloc: ImageSearchPhraseBloc(mockImageSearchDataProvider, initiateSearchObserver),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final hintFinder = find.text(hint);
      expect(hintFinder, findsOneWidget);

      expect(find.byType(DisabledSearchButton), findsOneWidget);
    });

    testWidgets('Search Button enabled for at least 2 chars typed and disabled for less',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            wrapWidget(
              BlocProvider(
                child: ImageSearchPhraseWidget(),
                bloc: ImageSearchPhraseBloc(mockImageSearchDataProvider, initiateSearchObserver),
              ),
            ),
          );
          await tester.pumpAndSettle();

          var searchTextFieldKey = Key('SearchTextField');

          expect(find.byKey(searchTextFieldKey), findsOneWidget);

          await tester.enterText(find.byKey(searchTextFieldKey), 'ab');

          await tester.pumpAndSettle();

          expect(find.byType(EnabledSearchButton), findsOneWidget);

          await tester.enterText(find.byKey(searchTextFieldKey), 'a');

          await tester.pumpAndSettle();

          expect(find.byType(DisabledSearchButton), findsOneWidget);
        });

    testWidgets('Search phrase is set when search button is clicked',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            wrapWidget(
              BlocProvider(
                child: ImageSearchPhraseWidget(),
                bloc: ImageSearchPhraseBloc(mockImageSearchDataProvider, initiateSearchObserver),
              ),
            ),
          );
          await tester.pumpAndSettle();

          var searchTextFieldKey = Key('SearchTextField');
          var searchButtonKey = Key('SearchButton');

          expect(find.byKey(searchTextFieldKey), findsOneWidget);

          await tester.enterText(find.byKey(searchTextFieldKey), testPhrase);

          await tester.pumpAndSettle();

          expect(find.byType(EnabledSearchButton), findsOneWidget);

          await tester.tap(find.byKey(searchButtonKey));

          //await tester.pumpAndSettle();

          expect(searchPhrase, testPhrase);

        });
  });
}
