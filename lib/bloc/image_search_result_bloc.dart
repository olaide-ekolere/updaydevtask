import 'dart:async';

import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/model/image_search_item.dart';

typedef LoadNextPageObserver();
class ImageSearchResultBloc extends BlocBase {
  final ImageSearchDataProvider imageSearchDataProvider;
  final LoadNextPageObserver loadNextPageObserver;
  ImageSearchResultBloc(this.imageSearchDataProvider, this.loadNextPageObserver) {
    _outLoadMore.listen((_){loadNextPageObserver();});
  }




  final _loadMoreStreamController = StreamController<void>.broadcast();

  StreamSink<void> get inLoadMore => _loadMoreStreamController.sink;

  Stream<void> get _outLoadMore => _loadMoreStreamController.stream;

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

  loadNextPage() async {
    _imageSearchResult.loadingMore = true;
    _inImageSearchResult.add(_imageSearchResult);

    imageSearchDataProvider.getImageSearchResults(
      _imageSearchResult.searchPhrase,
      _imageSearchResult.countPerPage,
      _imageSearchResult.currentPage + 1,
    ).then((imageSearchOperation){
      _imageSearchResult.loadingMore = false;
      if(imageSearchOperation.succeeded){
        _addNextPage(imageSearchOperation.results.imageSearchItems);
      }
      else{
        _inImageSearchResult.add(_imageSearchResult);
      }

    });
  }

  _addNextPage(
    List<ImageSearchItem> imageSearchItems,
  ) {
    _imageSearchResult.addNextPage(imageSearchItems);
    _inImageSearchResult.add(_imageSearchResult);
  }

  @override
  cancelOperation() {
    // TODO: implement cancelOperation
    return null;
  }
}
