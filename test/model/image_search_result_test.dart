import 'package:test/test.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';

void main() {
  group('Image Search Result', () {
    test('Verify when empty', () {
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        <ImageSearchItem>[],
        searchPhrase: 'searchPhrase',
        countPerPage: 10,
        totalNumberPages: 0,
      );
      expect(imageSearchResult.isEmpty, true);
    });

    test('Verify can load more', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
        searchPhrase: 'searchPhrase',
        countPerPage: 1,
        totalNumberPages: 10,
      );
      expect(imageSearchResult.canLoadMore, true);
    });

    test('Verify no more pages', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
        searchPhrase: 'searchPhrase',
        countPerPage: 1,
        totalNumberPages: 1,
      );
      expect(imageSearchResult.canLoadMore, false);
    });

    test('Page number Increases when page added, next page and can loading more', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
        searchPhrase: 'searchPhrase',
        countPerPage: 1,
        totalNumberPages: 10,
      );
      imageSearchResult.addNextPage(<ImageSearchItem>[ImageSearchItem('url', 'description')]);
      expect(imageSearchResult.currentPage, 2);
      expect(imageSearchResult.nextPage, 3);
      expect(imageSearchResult.canLoadMore, true);
    });

    test('Page number Increases when page added and no more pages', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
        searchPhrase: 'searchPhrase',
        countPerPage: 1,
        totalNumberPages: 2,
      );
      imageSearchResult.addNextPage(<ImageSearchItem>[ImageSearchItem('url', 'description')]);
      expect(imageSearchResult.currentPage, 2);
      expect(imageSearchResult.canLoadMore, false);
    });
  });
}
