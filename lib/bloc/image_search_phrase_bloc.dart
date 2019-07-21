import 'dart:async';

import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';

enum SearchStatus { Initialized, Fetching, Error, Done }

typedef InitiateSearchObserver(String searchPhrase);
typedef ImageSearchResultObserver(ImageSearchResult imageSearchResult);

class ImageSearchPhraseBloc extends BlocBase {
  final ImageSearchDataProvider imageSearchDataProvider;
  final int pageCount;
  //final InitiateSearchObserver initiateSearchObserver;

  ImageSearchPhraseBloc(
    this.imageSearchDataProvider,
    this.pageCount,
    //this.initiateSearchObserver,
  ) : assert(imageSearchDataProvider!=null)
  {
    searchStatus = SearchStatus.Initialized;
    outSearchPhrase.listen((searchPhrase)=>startSearchWithPhrase(searchPhrase, pageCount));
  }

  final _searchClickedStreamController = StreamController<String>.broadcast();

  StreamSink<String> get inSearchPhrase => _searchClickedStreamController.sink;

  Stream<String> get outSearchPhrase => _searchClickedStreamController.stream;


  final _imageSearchResultStreamController = StreamController<ImageSearchResult>.broadcast();

  StreamSink<ImageSearchResult> get _inImageSearchResult => _imageSearchResultStreamController.sink;

  Stream<ImageSearchResult> get outImageSearchResult => _imageSearchResultStreamController.stream;

  ReplaySubject<SearchStatus> _searchStatusController =
      ReplaySubject<SearchStatus>();

  Sink<SearchStatus> get _inSearchStatus => _searchStatusController.sink;

  Stream<SearchStatus> get outSearchStatus => _searchStatusController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchStatusController.close();
    _imageSearchResultStreamController.close();
    _searchClickedStreamController.close();
  }

  Future<void> startSearchWithPhrase(
    String searchPhrase,
    int pageCount,
  ) async {
    searchStatus = SearchStatus.Fetching;
    return imageSearchDataProvider
        .getImageSearchResults(
      searchPhrase,
      pageCount,
      1,
    )
        .then((imageSearchOperation) {
      if (imageSearchOperation == null || !imageSearchOperation.succeeded) {
        _inImageSearchResult.add(ImageSearchResult(searchPhrase: searchPhrase));
        _inSearchStatus.add(SearchStatus.Error);
      } else {
        _inImageSearchResult.add(imageSearchOperation.results);
        searchStatus = SearchStatus.Done;
      }
    })
    .catchError((error){
      _inImageSearchResult.add(ImageSearchResult(searchPhrase: searchPhrase));
      _inSearchStatus.add(SearchStatus.Error);
    });
  }

  set searchStatus(SearchStatus searchStatus) =>
      _inSearchStatus.add(searchStatus);

  @override
  cancelOperation() {
    // TODO: implement cancelOperation
    return null;
  }
}
