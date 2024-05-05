import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double defaultSize = 40.w;
    return Center(
        child: LoadingAnimationWidget.hexagonDots(
        color: Theme.of(context).primaryColor,
        size: size ??defaultSize,
    )
    );
  }
}
