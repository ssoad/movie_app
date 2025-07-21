// Network Info Interface and Implementation
// Provides network connectivity checking functionality

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for network connectivity checking
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation of NetworkInfo using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    
    // Check if any connection type is available (mobile, wifi, ethernet, etc.)
    return result.any((connectivityResult) => 
      connectivityResult != ConnectivityResult.none
    );
  }
}