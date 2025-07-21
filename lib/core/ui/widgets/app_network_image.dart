import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'app_loading.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          (context, url) =>
              placeholder ??
              AppShimmerLoading(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                borderRadius: borderRadius,
              ),
      errorWidget:
          (context, url, error) =>
              errorWidget ??
              Container(
                width: width,
                height: height,
                color: Theme.of(context).colorScheme.errorContainer,
                child: Icon(
                  Icons.broken_image,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  size: 32,
                ),
              ),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
