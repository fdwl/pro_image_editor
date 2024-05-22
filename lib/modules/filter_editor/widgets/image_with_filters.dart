// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:pro_image_editor/models/editor_image.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '../../../models/history/filter_state_history.dart';
import '../../../widgets/auto_image.dart';
import '../utils/generate_filtered_image.dart';

/// Represents an image with multiple filters applied.
///
/// This widget displays an image with multiple filters applied on top of it. It also supports blur effect.
class ImageWithFilters extends StatelessWidget {
  /// The width of the image.
  final double width;

  /// The height of the image.
  final double height;

  /// The design mode of the image editor.
  final ImageEditorDesignModeE designMode;

  /// The list of filter state histories to be applied on the image.
  final List<FilterStateHistory> filters;

  /// The editor image to display.
  final EditorImage image;

  /// How the image should be inscribed into the space allocated for it.
  final BoxFit fit;

  /// The blur factor
  final double blurFactor;

  const ImageWithFilters(
      {super.key,
      required this.width,
      required this.height,
      required this.designMode,
      required this.filters,
      required this.image,
      required this.blurFactor,
      this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    Widget img = AutoImage(
      image,
      fit: fit,
      width: width,
      height: height,
      designMode: designMode,
    );

    Widget filteredImg = img;
    for (var filter in filters) {
      filteredImg = generateFilteredImage(
        child: filteredImg,
        filter: filter.filter,
        opacity: filter.opacity,
      );
    }

    /*    print('-----------------------');
    print(width);
    print(height); */

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        // StackFit.expand is importent for [transformed_content_generator.dart]
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          img,
          filteredImg,
          ClipRect(
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurFactor, sigmaY: blurFactor),
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
