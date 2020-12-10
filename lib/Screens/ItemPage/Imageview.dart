import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ImageViewCustom extends StatelessWidget {
  String url;
  ImageViewCustom({this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        return Navigator.pop(context);
      },
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
