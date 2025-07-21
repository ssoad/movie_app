// Movie List Item
// Clean, modern, responsive, and dark mode supported

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/widgets/app_loading.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/widgets/app_network_image.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/cards/app_card.dart';

import '../../domain/entities/home_entity.dart';
import '../../data/models/home_model.dart';

class MovieListItem extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieListItem({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 500;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: AppCard(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
        border: Border.all(
          color:
              theme.brightness == Brightness.dark
                  ? theme.colorScheme.outline.withOpacity(0.32)
                  : theme.colorScheme.outline.withOpacity(0.18),
          width: 1.6,
        ),
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Container(
          height: isWide ? 180 : 135,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MoviePoster(movie: movie, isWide: isWide),
              const SizedBox(width: 18.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          movie.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Flexible(child: _MovieInfoChips(movie: movie)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieCardEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isDark;
  const _MovieCardEffect({
    required this.child,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_MovieCardEffect> createState() => _MovieCardEffectState();
}

class _MovieCardEffectState extends State<_MovieCardEffect>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: MediaQuery.of(context).size.width > 500 ? 180 : 135,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  widget.isDark
                      ? theme.colorScheme.surface.withOpacity(0.92)
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(
                        0.98,
                      ),
              border: Border.all(
                color:
                    widget.isDark
                        ? theme.colorScheme.primary.withOpacity(0.18)
                        : theme.colorScheme.primary.withOpacity(0.10),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      widget.isDark
                          ? Colors.black.withOpacity(0.22)
                          : theme.colorScheme.primary.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final MovieEntity movie;
  final bool isWide;
  const _MoviePoster({required this.movie, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: isWide ? 120 : 90,
      height: double.infinity, // Fill the card height
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: AppNetworkImage(
        url: movie.thumbnailUrl,
        fit: BoxFit.cover,
        width: isWide ? 120 : 90,
        height: double.infinity,
        borderRadius: null, // No radius for image
      ),
    );
  }
}

class _MovieInfoChips extends StatelessWidget {
  final MovieEntity movie;
  const _MovieInfoChips({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isModel = movie is MovieModel;
    final genre = isModel ? (movie as MovieModel).genre : 'Unknown';
    final year = isModel ? (movie as MovieModel).releaseYear.toString() : '-';
    final rating =
        isModel ? (movie as MovieModel).rating.toStringAsFixed(1) : '-';
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Chip(
            label: Text(
              genre,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: theme.colorScheme.primaryContainer.withOpacity(
              0.7,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 6),
          Chip(
            label: Text(
              year,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(
              0.7,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 6),
          Chip(
            avatar: const Icon(
              Icons.star_rounded,
              color: Colors.amber,
              size: 18,
              semanticLabel: 'Rating',
            ),
            label: Text(
              rating,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: theme.colorScheme.tertiaryContainer.withOpacity(
              0.7,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
