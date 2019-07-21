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
      elevation: 4.0,
      margin: EdgeInsets.all(
        4.0,
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(
                imageUrl: imageSearchItem.url,
                fit: BoxFit.fill,
                placeholder: (
                  context,
                  url,
                ) =>
                    Container(
                        child: Center(
                  child: Icon(
                    Icons.image,
                    size: 32.0,
                  ),
                )),
                errorWidget: (
                  context,
                  url,
                  error,
                ) =>
                    Container(
                        child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 32.0,
                  ),
                )),
              ),
            ),
            Container(
              height: 50.0,
              padding: const EdgeInsets.all(4.0),
              child: Text(
                imageSearchItem.description,
                style: Theme.of(context).textTheme.body1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
