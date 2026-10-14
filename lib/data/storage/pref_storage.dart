import '../../common_libraries.dart';

/// Singleton class for accessing shared prefs.
/// All the key-value fields saved in the app are declared here.
class Prefs {
  Prefs._();

  static late SharedPreferences prefs;

  /// Must be called before any prefs operation (done in main)
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Declared as getters (not final fields) so they always use the
  // current prefs instance - this also makes tests with mock values work.
  static SharedPrefValue<String> get cachedProducts =>
      SharedPrefValue<String>(PrefKeys.cachedProducts, prefs);

  static SharedPrefValue<String> get lastSyncedAt =>
      SharedPrefValue<String>(PrefKeys.lastSyncedAt, prefs);

  static SharedPrefValue<List<String>> get recentSearches =>
      SharedPrefValue<List<String>>(PrefKeys.recentSearches, prefs);

  static SharedPrefValue<List<String>> get favouriteIds =>
      SharedPrefValue<List<String>>(PrefKeys.favouriteIds, prefs);

  /// Clears all shared preference data
  static Future<void> clear() => prefs.clear();
}

class SharedPrefValue<T> {
  final String key;
  final SharedPreferences prefs;

  SharedPrefValue(this.key, this.prefs);

  Future<void> set(T value) async {
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported SharedPreferences type: ${value.runtimeType}');
    }
  }

  T? getSafe() {
    final value = prefs.get(key);

    // string lists come back as List<Object?> from prefs.get(), so cast them
    if (value is List) {
      final list = value.cast<String>().toList();
      return list is T ? list as T : null;
    }

    if (value is T) return value;
    return null;
  }

  T get() => getSafe() ?? _defaultValue();

  Future<void> clear() => prefs.remove(key);

  T _defaultValue() {
    if (T == int) return -1 as T;
    if (T == String) return "" as T;
    if (T == bool) return false as T;
    if (T == double) return 0.0 as T;
    if (<String>[] is T) return <String>[] as T;
    throw Exception('Unsupported SharedPreferences default for type $T');
  }
}
