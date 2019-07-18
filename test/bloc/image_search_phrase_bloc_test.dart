import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:upday_dev_task/bloc/image_search_phrase_bloc.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/image_search_operation.dart';

class MockImageSearchDataProvider extends Mock
    implements ImageSearchDataProvider {}

var searchPhrase = 'searchPhrase';
var searchPhraseTwo = 'searchPhraseTwo';
var errorMessage = 'AN Error Occurred';
var pageCount = 1;
var page = 1;
final successResult = ImageSearchResult.initWithImageSearchItems(
  [ImageSearchItem(url: '', description: '', width: 10, height: 10)],
  searchPhrase: searchPhrase,
  countPerPage: pageCount,
  totalNumberPages: 1,
);
final emptyResult = ImageSearchResult.initWithImageSearchItems(
  [],
  searchPhrase: searchPhrase,
  countPerPage: pageCount,
  totalNumberPages: 0,
);

ImageSearchResult imageSearchResult;

main() {
  group('ImageSearchPhraseBloc Tests', () {
    ImageSearchPhraseBloc imageSearchPhraseBloc;
    MockImageSearchDataProvider mockImageSearchDataProvider;
    ImageSearchResultObserver imageSearchResultObserver;
    setUp(() {
      mockImageSearchDataProvider = MockImageSearchDataProvider();
      imageSearchPhraseBloc =
          ImageSearchPhraseBloc(mockImageSearchDataProvider);
      imageSearchResultObserver = (result) {
        imageSearchResult = result;
      };
    });

    tearDown(() {
      imageSearchPhraseBloc.dispose();
    });

    test('initial state is correct', () {
      expect(
        imageSearchPhraseBloc.outSearchStatus,
        emits(SearchStatus.Initialized),
      );
    });

    test('fetching and done states when ok and fires observer', () async{
      when(mockImageSearchDataProvider.getImageSearchResults(
              searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(200, successResult));

      await imageSearchPhraseBloc.startSearchWithPhrase(
          searchPhrase, pageCount, imageSearchResultObserver);
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));
      expect(imageSearchResult.isEmpty, false);
    });

    test('fetching and done states when ok and fires observer for another search', () async{
      when(mockImageSearchDataProvider.getImageSearchResults(
          searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(200, successResult));

      await imageSearchPhraseBloc.startSearchWithPhrase(
          searchPhrase, pageCount, imageSearchResultObserver);
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));
      expect(imageSearchResult.isEmpty, false);

      when(mockImageSearchDataProvider.getImageSearchResults(
          searchPhraseTwo, pageCount, page))
          .thenAnswer((_)  => Future.value(ImageSearchOperation(200, successResult)));

      await imageSearchPhraseBloc.startSearchWithPhrase(
          searchPhraseTwo, pageCount, imageSearchResultObserver);
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));
      expect(imageSearchResult.isEmpty, false);
    });


    test('fetching and done states when error occurs', () async{
      when(mockImageSearchDataProvider.getImageSearchResults(
          searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(400, errorMessage));

      await imageSearchPhraseBloc.startSearchWithPhrase(
          searchPhrase, pageCount, imageSearchResultObserver);
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Error,
          ]));
      expect(imageSearchResult == null, false);
    });
  });
}
