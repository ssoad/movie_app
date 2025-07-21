// Movie Detail Screen
// Screen that displays details of a specific movie

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/widgets/app_loading.dart';
import 'dart:ui';
import 'dart:math';

import '../../providers/home_providers.dart';
import 'package:flutter_riverpod_clean_architecture/features/favourite/presentation/providers/favourite_provider.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/widgets/app_network_image.dart';
import 'movie_detail_dummy_data.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/buttons/app_button.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int? movieId;

  const MovieDetailScreen({super.key, this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movieId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedMovieIdProvider.notifier).state = movieId;
      });
    }

    final selectedMovieAsync = ref.watch(selectedMovieProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final media = MediaQuery.of(context);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.5,
        title: const Text('Movie Details'),
      ),
      body: selectedMovieAsync.when(
        data: (movie) {
          if (movie == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No movie selected',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final random = Random();

          return Stack(
            children: [
              // Hero Banner with Blur
              SizedBox(
                width: double.infinity,
                height: media.size.height * 0.32,
                child:
                    movie.url.isNotEmpty
                        ? AppNetworkImage(
                          url: movie.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: media.size.height * 0.32,
                          errorWidget: AppNetworkImage(
                            url:
                                dummyPosterUrls[random.nextInt(
                                  dummyPosterUrls.length,
                                )],
                          ),
                        )
                        : AppNetworkImage(
                          url:
                              'https://m.media-amazon.com/images/M/MV5BMTM0NjUxMDk5MF5BMl5BanBnXkFtZTcwNDMxNDY3Mw@@._V1_QL75_UX656_.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: media.size.height * 0.32,
                        ),
              ),
              //Blur overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.55)
                            : Colors.white.withOpacity(0.55),
                  ),
                ),
              ),
              // Main content
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: media.size.height * 0.15,
                  left: 0,
                  right: 0,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster, Title, and Key Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Poster
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: 150,
                                height: 195,
                                child: AppNetworkImage(
                                  url: movie.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 195,
                                  borderRadius: BorderRadius.circular(16),
                                  errorWidget: AppNetworkImage(
                                    url:
                                        dummyPosterUrls[random.nextInt(
                                          dummyPosterUrls.length,
                                        )],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Title and Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            movie.title,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      theme
                                                          .colorScheme
                                                          .onSurface,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _FavoritePillButton(movieId: movie.id),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        ...dummyGenres.map(
                                          (g) => Chip(
                                            label: Text(g),
                                            backgroundColor: theme
                                                .colorScheme
                                                .primaryContainer
                                                .withOpacity(0.7),
                                            labelStyle: theme
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                        _InfoChip(
                                          icon: Icons.access_time,
                                          label: dummyRuntime,
                                          color: theme.colorScheme.secondary,
                                        ),
                                        _InfoChip(
                                          icon: Icons.star_rounded,
                                          label: dummyRating.toStringAsFixed(1),
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favorite pill button
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 24.0,
                    //     top: 18.0,
                    //     bottom: 4.0,
                    //   ),
                    //   child: _FavoritePillButton(),
                    // ),
                    const SizedBox(height: 24),
                    // Trailer preview (dummy)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle_fill_rounded,
                                color: theme.colorScheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Watch Trailer',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 4, bottom: 16),
                          //   height: 2,
                          //   width: MediaQuery.of(context).size.width * 0.9,
                          //   decoration: BoxDecoration(
                          //     color: theme.colorScheme.primary.withOpacity(
                          //       0.18,
                          //     ),
                          //     borderRadius: BorderRadius.circular(2),
                          //   ),
                          // ),
                          Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: AppNetworkImage(
                                      url: dummyTrailerUrl,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  // Gradient overlay at bottom
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    height: 60,
                                    child: IgnorePointer(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.38),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Play button
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.32),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Description/Overview
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        dummyDescription,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Rating bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          // Simple star rating row (replace RatingBarIndicator)
                          Row(
                            children: List.generate(5, (index) {
                              final filled = index < dummyRating.round();
                              return Icon(
                                Icons.star_rounded,
                                color:
                                    filled
                                        ? Colors.amber
                                        : theme.colorScheme.onSurface
                                            .withOpacity(0.12),
                                size: 28.0,
                              );
                            }),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$dummyRating/5',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Cast
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cast',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 72,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: dummyCast.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 16),
                              itemBuilder: (context, i) {
                                final cast = dummyCast[i];
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: theme.colorScheme.primary
                                          .withOpacity(0.15),
                                      child: Text(
                                        cast['name']![0],
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cast['name']!,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Removed 'Image Information' section for realism
                  ],
                ),
              ),
            ],
          );
        },
        loading:
            () => const Center(
              child: AppLoading(message: 'Loading movie details...'),
            ),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading movie details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Retry',
                    icon: Icons.refresh,
                    onPressed: () {
                      ref.invalidate(selectedMovieProvider);
                    },
                    type: AppButtonType.elevated,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surfaceVariant.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      visualDensity: VisualDensity.compact,
    );
  }
}

// Replace _FavoritePillButton with a ConsumerStatefulWidget that persists favorite state
class _FavoritePillButton extends ConsumerWidget {
  final int movieId;
  const _FavoritePillButton({required this.movieId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isFavorite = ref.watch(favouriteNotifierProvider).contains(movieId);
    final notifier = ref.read(favouriteNotifierProvider.notifier);
    double _scale = 1.0;

    return Semantics(
      label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      button: true,
      child: GestureDetector(
        onTap: () async {
          _scale = 1.2;
          await notifier.toggleFavourite(movieId);
          Future.delayed(const Duration(milliseconds: 120), () {
            _scale = 1.0;
          });
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isFavorite
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (isFavorite)
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.red : theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  isFavorite ? 'Favorited' : 'Add to Favorites',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color:
                        isFavorite
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
