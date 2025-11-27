/// presentation/widgets/loading_overlay.dart
/// Shared shimmering placeholder for async content.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.isVisible = false});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.background.withOpacity(0.75),
        child: Center(
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryDark,
            highlightColor: AppColors.primary,
            child: const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

