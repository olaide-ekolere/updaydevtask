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
    setUp(() {
      mockImageSearchDataProvider = MockImageSearchDataProvider();
    });

    testWidgets('Search Hint displayed and Search Button disabled at launch',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          BlocProvider(
            child: ImageSearchPhraseWidget(),
            bloc: ImageSearchPhraseBloc(mockImageSearchDataProvider),
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
                bloc: ImageSearchPhraseBloc(mockImageSearchDataProvider),
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
  });
}
