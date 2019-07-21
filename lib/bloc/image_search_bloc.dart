import 'dart:async';

import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/model/image_search.dart';



class ImageSearchBloc extends BlocBase {

  ImageSearchBloc(ImageSearch imageSearch){
    _inImageSearch.add(imageSearch);
  }
  final _searchClickedStreamController = StreamController<String>.broadcast();

  //final ImageSearch _countPerPage = 20;
  BehaviorSubject<ImageSearch> _searchStatusController =
  BehaviorSubject<ImageSearch>();

  Sink<ImageSearch> get _inImageSearch => _searchStatusController.sink;

  Stream<ImageSearch> get outImageSearch => _searchStatusController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchStatusController.close();
    _searchClickedStreamController.close();
  }

  @override
  cancelOperation() {
    // TODO: implement cancelOperation
    return null;
  }
}
