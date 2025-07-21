import 'package:flutter/material.dart';

/// A reusable card widget following Material Design principles
/// Provides consistent styling and behavior across the app
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        child: Material(
          color: backgroundColor ?? theme.cardColor,
          elevation: elevation ?? 2.0,
          borderRadius: borderRadius ?? BorderRadius.circular(12.0),
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(12.0),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16.0),
              decoration:
                  border != null
                      ? BoxDecoration(
                        border: border,
                        borderRadius:
                            borderRadius ?? BorderRadius.circular(12.0),
                      )
                      : null,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
