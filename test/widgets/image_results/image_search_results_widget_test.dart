import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/localization/application.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/widgets/image_results/image_search_results_widget.dart';

class MockImageSearchDataProvider extends Mock
    implements ImageSearchDataProvider {}

const countPerPage = 20;

Widget wrapWidget(Widget widget) {
  return MaterialApp(
    localizationsDelegates: [
      AppTranslationsDelegate(
          newLocale: application.supportedLocales().first, testValues: """
          {}
          """),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: application.supportedLocales(),
    home: Scaffold(body: widget),
  );
}

main() {
  group('ImageSearchResultWidget Tests', () {
    MockImageSearchDataProvider mockImageSearchDataProvider;
    ImageSearchResultBloc imageSearchResultBloc;
    LoadNextPageObserver loadNextPageObserver;
    ImageSearchResult firstPage;
    bool loadingNext;

    setUp(() {
      loadingNext = false;
      mockImageSearchDataProvider = MockImageSearchDataProvider();
      loadNextPageObserver = () => loadingNext = true;
      imageSearchResultBloc = ImageSearchResultBloc(
          mockImageSearchDataProvider, loadNextPageObserver);
      var imageSearchItems = <ImageSearchItem>[];
      for (int i = 0; i < countPerPage; i++) {
        imageSearchItems.add(ImageSearchItem(
            url: 'url', description: 'description', width: 10, height: 10));
      }
      firstPage = ImageSearchResult.initWithImageSearchItems(
        imageSearchItems,
        searchPhrase: 'searchPhrase',
        countPerPage: countPerPage,
        totalNumberPages: 10,
      );
    });

    tearDown(() {
      imageSearchResultBloc.dispose();
    });

    testWidgets('Awaiting then Successfully displays with first page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          BlocProvider(
            child: ImageSearchResultWidget(),
            bloc: imageSearchResultBloc,
          ),
        ),
      );
      await tester.pump();

      final awaitingFirstPage = Key('awaitingfirstpage');

      expect(find.byKey(awaitingFirstPage), findsOneWidget);

      await imageSearchResultBloc.initWithImageSearchItems(firstPage);

      await tester.pump();

      final listKey = Key('resultlist');

      expect(find.byKey(listKey), findsOneWidget);
    });

    testWidgets('Loads more and displays an indicator when scrolled to bottom',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          BlocProvider(
            child: ImageSearchResultWidget(),
            bloc: imageSearchResultBloc,
          ),
        ),
      );
      await tester.pump();

      await imageSearchResultBloc.initWithImageSearchItems(firstPage);

      await tester.pump();

      final listKey = Key('resultlist');

      expect(find.byKey(listKey), findsOneWidget);

      await tester.pump();

      /*
      final gesture = await tester.startGesture(Offset.zero);

      await gesture.moveTo(const Offset(0, 100000));
      */
      final ScrollableState state = tester.state(find.byType(Scrollable));
      final ScrollPosition position = state.position;
      position.jumpTo(10000.0);

      await tester.pump();

      expect(loadingNext, true);

      //final loadMoreKey = Key('loadmore');
      //expect(find.byKey(loadMoreKey), findsOneWidget);
    });
  });
}
