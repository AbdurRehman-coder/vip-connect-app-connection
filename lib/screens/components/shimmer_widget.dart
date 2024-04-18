import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  // const ShimmerWidget({Key? key}) : super(key: key);
  double height;
  double width;
  final ShapeBorder shapeBorder;
  ShimmerWidget.rectangular({
    required this.width,
    required this.height,
  }) : shapeBorder =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(08));

  /// for cicle
  ShimmerWidget.circular({
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey.shade400,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
