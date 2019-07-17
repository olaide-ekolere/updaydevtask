import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';

class ImageSearchResultBloc extends BlocBase {
  BehaviorSubject<ImageSearchResult> _imageSearchResultController =
      BehaviorSubject<ImageSearchResult>();

  Sink<ImageSearchResult> get _inImageSearchResult =>
      _imageSearchResultController.sink;

  Stream<ImageSearchResult> get outImageSearchResult =>
      _imageSearchResultController.stream;
  ImageSearchResult _imageSearchResult;

  @override
  void dispose() {
    // TODO: implement dispose
    _imageSearchResultController.close();
  }

  initWithImageSearchItems(
    ImageSearchResult imageSearchResult,
  ) {
    _imageSearchResult = imageSearchResult;
    _inImageSearchResult.add(_imageSearchResult);
  }

  loadNextPage(
    ImageSearchDataProvider imageSearchDataProvider,
  ) async {
    _imageSearchResult.loadingMore = true;
    _inImageSearchResult.add(_imageSearchResult);

    imageSearchDataProvider.getImageSearchResults(
      _imageSearchResult.searchPhrase,
      _imageSearchResult.countPerPage,
      _imageSearchResult.currentPage + 1,
    ).then((imageSearchOperation){
      if(imageSearchOperation.succeeded){
        _imageSearchResult.addNextPage(imageSearchOperation.results.imageSearchItems);
      }
      _imageSearchResult.loadingMore = false;

    });
  }

  _addNextPage(
    List<ImageSearchItem> imageSearchItems,
  ) {
    _imageSearchResult.addNextPage(imageSearchItems);
    _inImageSearchResult.add(_imageSearchResult);
  }
}
