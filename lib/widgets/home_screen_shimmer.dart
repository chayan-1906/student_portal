import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../services/color_themes.dart';

Widget HomeScreenShimmer({double height, double width}) {
  return Container(
    height: height * 0.38 - width * 0.05,
    width: width * 0.94,
    child: Shimmer.fromColors(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(height * 0.05),
        ),
      ),
      baseColor: Colors.white38,
      highlightColor: ColorThemes.primaryColor,
    ),
  );
}