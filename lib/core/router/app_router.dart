import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/core/constants/app_constants.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod_clean_architecture/features/home/presentation/screens/home_list_screen.dart';
import 'package:flutter_riverpod_clean_architecture/features/home/presentation/screens/home_detail_screen.dart';

import 'package:flutter_riverpod_clean_architecture/features/favourite/presentation/screens/favourite_list_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppConstants.initialRoute,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // No redirect needed
      return null;
    },
    routes: [
      // Home route
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const MovieListScreen(),
        routes: [
          // Photo detail route
          GoRoute(
            path: '/movie/:id',
            name: 'photo_detail',
            builder: (context, state) {
              final photoId = int.tryParse(state.pathParameters['id'] ?? '');
              return MovieDetailScreen(movieId: photoId);
            },
          ),
          // Favourites list route
          GoRoute(
            path: 'favourites',
            name: 'favourites',
            builder: (context, state) => const FavouriteListScreen(),
          ),
        ],
      ),

      // Login route
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Initial route - redirects based on auth state
      GoRoute(
        path: AppConstants.initialRoute,
        name: 'initial',
        redirect:
            (_, __) =>
                authState.isAuthenticated
                    ? AppConstants.homeRoute
                    : AppConstants.loginRoute,
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '404',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Page ${state.uri.path} not found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(AppConstants.homeRoute),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );
});
