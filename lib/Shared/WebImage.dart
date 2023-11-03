import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Shared/Loading.dart';

class WebImage extends StatelessWidget {

  final String? url;
  final double? width;
  final double? height;
  const WebImage({Key? key, required this.url, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (url == null) {
    //   return Image.asset('assets/images/bag_1.png',);
    // }
    // CachedNetworkImageProvider(url)
    // Image(image: CachedNetworkImageProvider('https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg'));
    return CachedNetworkImage(
      imageUrl: url!, //url!,
      placeholder: (context, url) => const Loading(fullHeight: false, size: 70),
     // progressIndicatorBuilder: (context, url, downloadProgress) => const Loading(fullHeight: false, size: 70),
      errorWidget: (context, url, error) => Image.asset('assets/images/bag_1.png'),
    );


    return Image.network(url!,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Image.asset('assets/images/bag_1.png');
      },
      cacheWidth: 400,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.network('https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg');
      }
    );
  }
}