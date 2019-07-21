import 'dart:async';

import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';

typedef LoadNextPageObserver();

class ImageSearchResultBloc extends BlocBase {
  final ImageSearchDataProvider imageSearchDataProvider;

  //final LoadNextPageObserver loadNextPageObserver;
  final int pageCount;

  ImageSearchResultBloc(this.imageSearchDataProvider, this.pageCount) {
    outLoadMore.listen((_) {
      loadNextPage();
    });
    _inImageSearchResult.add(ImageSearchResult());
  }

  final _loadMoreStreamController = StreamController<void>.broadcast();

  StreamSink<void> get inLoadMore => _loadMoreStreamController.sink;

  Stream<void> get outLoadMore => _loadMoreStreamController.stream;

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
    _loadMoreStreamController.close();
    _imageSearchResultController.close();
  }

  initWithImageSearchItems(
    ImageSearchResult imageSearchResult,
  ) {
    _imageSearchResult = imageSearchResult;
    _inImageSearchResult.add(_imageSearchResult);
  }

  Future<void> loadNextPage() async {
    ImageSearchResult clone = ImageSearchResult.clone(_imageSearchResult);
    _imageSearchResult.loadingMore = true;

    return imageSearchDataProvider
        .getImageSearchResults(
      _imageSearchResult.searchPhrase,
      _imageSearchResult.countPerPage,
      _imageSearchResult.currentPage + 1,
    )
        .then((imageSearchOperation) {
      _imageSearchResult.loadingMore = false;
      if (imageSearchOperation.succeeded) {
        clone.addNextPage(imageSearchOperation.results.imageSearchItems);
        _imageSearchResult = clone;
        _inImageSearchResult.add(_imageSearchResult);
      } else {
        _inImageSearchResult.add(_imageSearchResult);
      }
    }).catchError((_) {
      _imageSearchResult.loadingMore = false;
      _inImageSearchResult.add(_imageSearchResult);
    });
  }

  @override
  cancelOperation() {
    // TODO: implement cancelOperation
    return null;
  }
}
