import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod_clean_architecture/core/error/failures.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/usecases/logout_use_case.dart';

// Fake LoginUseCase
class FakeLoginUseCase extends LoginUseCase {
  FakeLoginUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, UserEntity>> execute({
    required String email,
    required String password,
  }) async {
    return Right(
      const UserEntity(id: '1', name: 'Test User', email: 'test@example.com'),
    );
  }
}

// Fake LogoutUseCase
class FakeLogoutUseCase extends LogoutUseCase {
  FakeLogoutUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, void>> execute() async {
    return const Right(null);
  }
}

// Fake AuthRepository
class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return Right(
      const UserEntity(id: '1', name: 'Test User', email: 'test@example.com'),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    return Right(
      const UserEntity(id: '1', name: 'Test User', email: 'test@example.com'),
    );
  }
}

final fakeAuthRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);
final fakeLoginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => FakeLoginUseCase(),
);
final fakeLogoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => FakeLogoutUseCase(),
);

// A fake AuthNotifier for testing
class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier()
    : super(
        loginUseCase: FakeLoginUseCase(),
        logoutUseCase: FakeLogoutUseCase(),
      );
}

void main() {
  final fakeAuthProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => FakeAuthNotifier(),
  );
  testWidgets('LoginScreen displays and validates form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWithProvider(fakeAuthProvider),
          authRepositoryProvider.overrideWithProvider(
            fakeAuthRepositoryProvider,
          ),
          loginUseCaseProvider.overrideWithProvider(fakeLoginUseCaseProvider),
          logoutUseCaseProvider.overrideWithProvider(fakeLogoutUseCaseProvider),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    // Check for presence of email and password fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Try to tap login without entering anything
    await tester.tap(find.text('Log In'));
    await tester.pump();

    // Should show validation error
    expect(find.textContaining('Please enter your email'), findsOneWidget);

    // Enter email and password
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap login again
    await tester.tap(find.text('Log In'));
    await tester.pump();

    // You can add more expectations here, e.g. loading indicator, navigation, etc.
  });
}
