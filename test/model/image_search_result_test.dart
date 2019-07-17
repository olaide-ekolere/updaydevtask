import 'package:test/test.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';

void main() {
  group('Image Search Result', () {
    test('Verify when empty', () {
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        'searchPhrase',
        10,
        0,
        <ImageSearchItem>[],
      );
      expect(imageSearchResult.isEmpty, true);
    });

    test('Verify can load more', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        'searchPhrase',
        1,
        10,
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
      );
      expect(imageSearchResult.canLoadMore, true);
    });

    test('Verify no more pages', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        'searchPhrase',
        1,
        1,
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
      );
      expect(imageSearchResult.canLoadMore, false);
    });

    test('Page number Increases when page added and can loading more', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        'searchPhrase',
        1,
        10,
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
      );
      imageSearchResult.addNextPage(<ImageSearchItem>[ImageSearchItem('url', 'description')]);
      expect(imageSearchResult.currentPage, 2);
      expect(imageSearchResult.canLoadMore, true);
    });

    test('Page number Increases when page added and no more pages', (){
      final imageSearchResult = ImageSearchResult.initWithImageSearchItems(
        'searchPhrase',
        1,
        2,
        <ImageSearchItem>[ImageSearchItem('url', 'description')],
      );
      imageSearchResult.addNextPage(<ImageSearchItem>[ImageSearchItem('url', 'description')]);
      expect(imageSearchResult.currentPage, 2);
      expect(imageSearchResult.canLoadMore, false);
    });
  });
}
