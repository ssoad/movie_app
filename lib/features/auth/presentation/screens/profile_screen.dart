import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod_clean_architecture/core/constants/app_constants.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod_clean_architecture/features/home/presentation/providers/tab_index_provider.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/buttons/app_button.dart';
import 'package:flutter_riverpod_clean_architecture/core/ui/dialogs/app_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (previous?.isAuthenticated == true && next.isAuthenticated == false) {
        // Reset tab index to Home
        ref.read(homeTabIndexProvider.notifier).state = 0;
        // Redirect to login after logout
        context.go(AppConstants.loginRoute);
      }
    });

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    if (user == null) {
      // Not authenticated or user not loaded
      return Scaffold(
        body: Center(
          child: Text(
            'No user data available.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    final avatarUrl =
        user.profilePicture ?? 'https://randomuser.me/api/portraits/men/32.jpg';
    final name = user.name;
    final email = user.email;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                ),
                const SizedBox(height: 24),
                Text(
                  name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      label: 'Edit Profile',
                      icon: Icons.edit_rounded,
                      onPressed: () {},
                      type: AppButtonType.elevated,
                    ),
                    const SizedBox(width: 16),
                    AppButton(
                      label: authState.isLoading ? '' : 'Logout',
                      icon: Icons.logout_rounded,
                      onPressed:
                          authState.isLoading
                              ? null
                              : () async {
                                final confirmed = await AppDialog.show(
                                  context: context,
                                  title: 'Logout',
                                  content: const Text(
                                    'Are you sure you want to log out?',
                                  ),
                                  icon: Icons.logout_rounded,
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                                if (confirmed == true) {
                                  await ref
                                      .read(authProvider.notifier)
                                      .logout();
                                }
                              },
                      type: AppButtonType.outlined,
                      loading: authState.isLoading,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
