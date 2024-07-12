import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonCacheImage extends StatelessWidget {
  final String imageUrl;
  final double width, height;

  const PersonCacheImage(
      {Key? key,
      required this.imageUrl,
      required this.width,
      required this.height})
      : super(key: key);

  Widget _imageWidget(ImageProvider) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          image: DecorationImage(image: ImageProvider, fit: BoxFit.cover)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, ImageProvider) {
        return _imageWidget(ImageProvider);
      },
      placeholder: (context, url) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, url, error) {
        return _imageWidget(AssetImage('assets/images/noimage.jpg'));
      },
    );
  }
}
