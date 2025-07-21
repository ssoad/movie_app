// Uhome UI Providers
// Riverpod providers specific to UI state

import 'package:flutter_riverpod/flutter_riverpod.dart';

// UI state providers
final LUhomeFilterProvider = StateProvider<String>((ref) => '');

final LUhomeSortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.asc);

enum SortOrder { asc, desc }
