import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



//one network image
class NetworkPhotoView extends StatelessWidget {
  const NetworkPhotoView({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        maxScale: PhotoViewComputedScale.contained * 2.0,
        minScale: PhotoViewComputedScale.contained * 1,
      ),
    );
  }
}

//one file image
class FilePhotoView extends StatelessWidget {
  const FilePhotoView({Key? key, required this.imageFile}) : super(key: key);

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PhotoView(
            imageProvider: FileImage(imageFile),
            maxScale: PhotoViewComputedScale.contained * 2.0,
            minScale: PhotoViewComputedScale.contained * 1,
          ),
        ],
      ),
    );
  }
}
