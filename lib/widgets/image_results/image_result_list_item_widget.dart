import 'package:flutter/material.dart';
import 'package:upday_dev_task/model/image_search_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageResultListItemWidget extends StatelessWidget {
  final ImageSearchItem imageSearchItem;

  ImageResultListItemWidget(this.imageSearchItem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: Container(
        child: CachedNetworkImage(
          imageUrl: imageSearchItem.url,
          placeholder: (
            context,
            url,
          ) =>
              CircularProgressIndicator(),
          errorWidget: (
            context,
            url,
            error,
          ) =>
              Icon(
            Icons.error,
          ),
        ),
      ),
    );
  }
}
