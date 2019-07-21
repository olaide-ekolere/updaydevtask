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

//ImageSearchResult imageSearchResult;

main() {
  group('ImageSearchPhraseBloc Tests', () {
    ImageSearchPhraseBloc imageSearchPhraseBloc;
    MockImageSearchDataProvider mockImageSearchDataProvider;
    
    setUp(() {
      mockImageSearchDataProvider = MockImageSearchDataProvider();
      imageSearchPhraseBloc = ImageSearchPhraseBloc(
        mockImageSearchDataProvider,
        pageCount
      );
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

    test('fetching and done states when ok', () async {
      when(mockImageSearchDataProvider.getImageSearchResults(
              searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(200, successResult));

      await imageSearchPhraseBloc.startSearchWithPhrase(
        searchPhrase,
        pageCount,
      );
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));
    });

    test('Notifies on successfull', ()  {
      when(mockImageSearchDataProvider.getImageSearchResults(
          searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(200, successResult));

       imageSearchPhraseBloc.startSearchWithPhrase(
        searchPhrase,
        pageCount,
      );
      expect(imageSearchPhraseBloc.outImageSearchResult, emits(successResult));
    });

    test(
        'Fetch and done states after a previous search',
        () async {
      when(mockImageSearchDataProvider.getImageSearchResults(
              searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(200, successResult));

      await imageSearchPhraseBloc.startSearchWithPhrase(
        searchPhrase,
        pageCount,
      );
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));

      when(mockImageSearchDataProvider.getImageSearchResults(
              searchPhraseTwo, pageCount, page))
          .thenAnswer(
              (_) => Future.value(ImageSearchOperation(200, successResult)));

      await imageSearchPhraseBloc.startSearchWithPhrase(
        searchPhraseTwo,
        pageCount,
      );
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Done,
            SearchStatus.Fetching,
            SearchStatus.Done,
          ]));
    });


    test('fetching and done states when error occurs', () async {
      when(mockImageSearchDataProvider.getImageSearchResults(
              searchPhrase, pageCount, page))
          .thenAnswer((_) async => ImageSearchOperation(400, errorMessage));

      await imageSearchPhraseBloc.startSearchWithPhrase(
        searchPhrase,
        pageCount,
      );
      expect(
          imageSearchPhraseBloc.outSearchStatus,
          emitsInOrder([
            SearchStatus.Initialized,
            SearchStatus.Fetching,
            SearchStatus.Error,
          ]));
    });
  });
}
