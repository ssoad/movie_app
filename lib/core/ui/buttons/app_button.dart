import 'package:flutter/material.dart';

enum AppButtonType { elevated, outlined, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool loading;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.elevated,
    this.loading = false,
    this.icon,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.iconColor,
    this.borderRadius = 12,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget child =
        loading
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ??
                          (type == AppButtonType.elevated
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            )
            : Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color:
                        iconColor ??
                        (type == AppButtonType.outlined
                            ? (textColor ?? theme.colorScheme.primary)
                            : (textColor ??
                                (type == AppButtonType.elevated
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary))),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    color:
                        textColor ??
                        (type == AppButtonType.outlined
                            ? theme.colorScheme.primary
                            : (type == AppButtonType.elevated
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary)),
                  ),
                ),
              ],
            );

    final buttonChild =
        fullWidth ? SizedBox(width: double.infinity, child: child) : child;

    final ButtonStyle style = ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(
        Size(width ?? 0, height ?? 48),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      backgroundColor:
          type == AppButtonType.elevated
              ? MaterialStateProperty.all<Color>(
                color ?? theme.colorScheme.primary,
              )
              : null,
      foregroundColor: MaterialStateProperty.all<Color>(
        textColor ??
            (type == AppButtonType.outlined
                ? theme.colorScheme.primary
                : (type == AppButtonType.elevated
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary)),
      ),
      side:
          type == AppButtonType.outlined
              ? MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: color ?? theme.colorScheme.primary,
                  width: 1.5,
                ),
              )
              : null,
      elevation:
          type == AppButtonType.elevated
              ? MaterialStateProperty.all<double>(2)
              : MaterialStateProperty.all<double>(0),
    );

    switch (type) {
      case AppButtonType.elevated:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: buttonChild,
        );
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: buttonChild,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: buttonChild,
        );
    }
  }
}
