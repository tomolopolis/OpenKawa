import 'package:flutter/material.dart';

import '../theme/open_kawa_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.assetPath,
    required this.child,
  });

  final String assetPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: OpenKawaColors.warmCream,
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              opacity: 0.18,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                OpenKawaColors.warmCream.withValues(alpha: 0.55),
                OpenKawaColors.warmCream.withValues(alpha: 0.75),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
