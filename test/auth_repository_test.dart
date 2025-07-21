import 'package:flutter_riverpod_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_riverpod_clean_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod_clean_architecture/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return UserModel(id: '1', name: 'Test User', email: email);
  }
}

class MockLocalStorageService implements LocalStorageService {
  final Map<String, dynamic> _storage = {};
  @override
  Future<bool> setObject(String key, Object value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _storage[key] as String?;
  @override
  dynamic getObject(String key) => _storage[key];
  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _storage[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _storage[key] as bool?;
  @override
  Future<bool> setInt(String key, int value) async {
    _storage[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _storage[key] as int?;
  @override
  Future<bool> setDouble(String key, double value) async {
    _storage[key] = value;
    return true;
  }

  @override
  double? getDouble(String key) => _storage[key] as double?;
  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _storage[key] = value;
    return true;
  }

  @override
  List<String>? getStringList(String key) => _storage[key] as List<String>?;
  @override
  bool hasKey(String key) => _storage.containsKey(key);
  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }
}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource remoteDataSource;
  late MockLocalStorageService localStorageService;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localStorageService = MockLocalStorageService();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localStorageService: localStorageService,
    );
  });

  test('login returns UserEntity on success', () async {
    final result = await repository.login(
      email: 'test@example.com',
      password: 'password',
    );
    expect(result.isRight(), true);
    expect(
      result.getOrElse(() => UserEntity.empty()).email,
      'test@example.com',
    );
  });
}
