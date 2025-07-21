// Movie List Screen
// Screen that displays a list of movie items with pagination

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod_clean_architecture/core/constants/app_constants.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/widgets/app_loading.dart';
import 'dart:ui';

import '../../providers/home_providers.dart';
import '../widgets/movie_list_item.dart';

import 'package:flutter_riverpod_clean_architecture/features/home/presentation/providers/tab_index_provider.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near the bottom
      ref.read(moviesListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(moviesListProvider);
    final isLoadingMore = ref.watch(isLoadingMoreProvider);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget homeBody = moviesAsync.when(
      data: (movies) {
        if (movies.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_outlined,
                    size: 80,
                    color: theme.colorScheme.primary.withOpacity(0.25),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No movies available',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try refreshing or check back later.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(moviesListProvider.notifier).refresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: media.size.width < 500 ? 16 : 32,
                  left: media.size.width < 500 ? 0 : 32,
                  right: media.size.width < 500 ? 0 : 32,
                  bottom: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= movies.length) {
                      // Loading indicator at the bottom
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: AppLoading(
                          message: 'Loading more movies...',
                          size: 24,
                        ),
                      );
                    }
                    final movie = movies[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: MovieListItem(
                        movie: movie,
                        onTap: () {
                          ref.read(selectedMovieIdProvider.notifier).state =
                              movie.id;
                          context.go(
                            '${AppConstants.homeRoute}/movie/${movie.id}',
                          );
                        },
                      ),
                    );
                  }, childCount: movies.length + (isLoadingMore ? 1 : 0)),
                ),
              ),
            ],
          ),
        );
      },
      loading:
          () => const Center(child: AppLoading(message: 'Loading movies...')),
      error:
          (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: theme.colorScheme.error.withOpacity(0.25),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Error loading movies',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(moviesListProvider.notifier).refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    final List<Widget> _pages = [
      homeBody,
      homeBody,
      homeBody
    ];

    final currentIndex = ref.watch(homeTabIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentIndex == 0
              ? 'Movies'
              : currentIndex == 1
              ? 'Favorites'
              : 'Profile',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(moviesListProvider.notifier).refresh();
              },
              tooltip: 'Refresh',
            ),
        ],
      ),
      backgroundColor:
          isDark ? theme.colorScheme.background : const Color(0xFFF4F6FB),
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(homeTabIndexProvider.notifier).state = index;
            },
            backgroundColor: theme.colorScheme.surface,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
