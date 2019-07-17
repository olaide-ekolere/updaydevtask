import 'package:upday_dev_task/model/image_search_item.dart';

class ImageSearchResult {
  final String searchPhrase;
  final int countPerPage;
  final int totalNumberPages;

  List<ImageSearchItem> _imageSearchItems = [];
  int _currentPage;
  bool loadingMore = false;

  ImageSearchResult.initWithImageSearchItems(
    List<ImageSearchItem> imageSearchItems, {
    this.searchPhrase,
    this.countPerPage,
    this.totalNumberPages,
    int currentPage = 1,
  })  : assert(searchPhrase != null),
        assert(countPerPage != null),
        assert(imageSearchItems != null) {
    this._currentPage = currentPage;
    _imageSearchItems.addAll(imageSearchItems);
  }

  addNextPage(
    List<ImageSearchItem> imageSearchItems,
  ) {
    assert((_currentPage == (totalNumberPages - 1)) ||
        (_currentPage != (totalNumberPages - 1) &&
            imageSearchItems.length == countPerPage));
    _currentPage += 1;
  }

  bool get isEmpty => _imageSearchItems.length == 0;

  int get currentPage => _currentPage;

  int get nextPage => _currentPage + 1;

  List<ImageSearchItem> get imageSearchItems => _imageSearchItems;

  bool get canLoadMore => currentPage != totalNumberPages;
}
