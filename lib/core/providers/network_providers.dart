// Network Providers
// Riverpod providers for network-related services

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';

/// Provider for Connectivity instance
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

/// Provider for NetworkInfo implementation
final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(ref.read(connectivityProvider)),
);

/// Provider for ApiClient instance
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());