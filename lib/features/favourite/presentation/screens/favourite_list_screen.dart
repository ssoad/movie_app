import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/features/favourite/presentation/providers/favourite_provider.dart';
import 'package:flutter_riverpod_clean_architecture/features/home/presentation/widgets/movie_list_item.dart';
import 'package:flutter_riverpod_clean_architecture/features/home/providers/home_providers.dart';
import 'package:flutter_riverpod_clean_architecture/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class FavouriteListScreen extends ConsumerWidget {
  const FavouriteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favouriteNotifierProvider);
    final moviesAsync = ref.watch(moviesListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Favorites'),
      //   backgroundColor: theme.colorScheme.surface,
      //   elevation: 0.5,
      // ),
      body: moviesAsync.when(
        data: (movies) {
          final favoriteMovies =
              movies.where((m) => favoriteIds.contains(m.id)).toList();
          if (favoriteMovies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add movies to your favorites to see them here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return MovieListItem(
                movie: movie,
                onTap: () {
                  // Navigate to detail screen
                  context.push('${AppConstants.homeRoute}/movie/${movie.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text(
                'Error loading movies',
                style: theme.textTheme.bodyMedium,
              ),
            ),
      ),
    );
  }
}
