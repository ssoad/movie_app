import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/usecases/logout_use_case.dart';

// Auth state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState());

  // Check auth status
  Future<void> checkAuthStatus() async {
    // Here you would typically check if there's a valid token stored
    // and validate it with your API if necessary

    // For now, we'll just return false
    state = state.copyWith(isAuthenticated: false, user: null);
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _loginUseCase.execute(
      email: email,
      password: password,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            errorMessage: failure.message,
          ),
      (user) =>
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
            errorMessage: null,
          ),
    );
  }


  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _logoutUseCase.execute();

    result.fold(
      (failure) =>
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
      (_) =>
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            user: null,
            errorMessage: null,
          ),
    );
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
  );
});
