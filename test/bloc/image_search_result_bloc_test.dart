import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:upday_dev_task/bloc/image_search_result_bloc.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/image_search_operation.dart';

class MockImageSearchDataProvider extends Mock
    implements ImageSearchDataProvider {}

var searchPhrase = 'searchPhrase';
var errorMessage = 'AN Error Occurred';
var pageCount = 1;
var page = 1;
var imageSearchItems = [
  ImageSearchItem(url: '', description: '', width: 10, height: 10)
];

var firstPage = ImageSearchResult.initWithImageSearchItems(
  imageSearchItems,
  searchPhrase: searchPhrase,
  totalNumberPages: 10,
  currentPage: 1,
  countPerPage: pageCount
);

var secondPage = ImageSearchResult.initWithImageSearchItems(
    imageSearchItems,
    searchPhrase: searchPhrase,
    totalNumberPages: 10,
    currentPage: 2,
    countPerPage: pageCount
);

main() {
  group('ImageSearchResultBloc Tests', () {
    MockImageSearchDataProvider mockImageSearchDataProvider;
    ImageSearchResultBloc imageSearchResultBloc;

    setUp(() {
      mockImageSearchDataProvider = MockImageSearchDataProvider();
      imageSearchResultBloc =
          ImageSearchResultBloc(mockImageSearchDataProvider,(){});
    });

    tearDown(() {
      imageSearchResultBloc.dispose();
    });

    test('Successfully Initialized with first page', () {
      imageSearchResultBloc.initWithImageSearchItems(firstPage);
      expect(imageSearchResultBloc.outImageSearchResult, emits(firstPage));
    });

    test('Successfully loads second page', () async{
      imageSearchResultBloc.initWithImageSearchItems(firstPage);

      when(mockImageSearchDataProvider.getImageSearchResults(
          searchPhrase, pageCount, firstPage.currentPage+1))
          .thenAnswer((_) async => ImageSearchOperation(200, secondPage));

      await imageSearchResultBloc.loadNextPage();
      expect(imageSearchResultBloc.outImageSearchResult, emits(firstPage..addNextPage(secondPage.imageSearchItems)));
    });
  });
}
