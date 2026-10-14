import '../../common_libraries.dart';

/// Everything we keep on the device:
/// 1. first page of products  -> so the app still shows something offline
/// 2. recent search keywords
/// 3. favourite product ids
class ProductLocalStorage {
  static const int _maxRecentSearches = 6;

  // ---------------- Product cache ----------------

  Future<void> cacheProducts(List<ProductModel> products) async {
    final encoded = jsonEncode(products.map((e) => e.toJson()).toList());
    await Prefs.cachedProducts.set(encoded);
    await Prefs.lastSyncedAt.set(DateTime.now().toIso8601String());
  }

  List<ProductModel> getCachedProducts() {
    final raw = Prefs.cachedProducts.get();
    if (raw.isEmpty) return [];

    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      // corrupted / old format cache, just ignore it
      debugPrint("Failed to read cached products: $e");
      return [];
    }
  }

  DateTime? getLastSyncedAt() => DateTime.tryParse(Prefs.lastSyncedAt.get());

  // ---------------- Recent searches ----------------

  List<String> getRecentSearches() => Prefs.recentSearches.get();

  /// Newest keyword goes on top, duplicates are removed.
  Future<List<String>> addRecentSearch(String query) async {
    final keyword = query.trim();
    if (keyword.isEmpty) return getRecentSearches();

    final list = getRecentSearches()
      ..removeWhere((e) => e.toLowerCase() == keyword.toLowerCase())
      ..insert(0, keyword);

    final trimmed = list.take(_maxRecentSearches).toList();
    await Prefs.recentSearches.set(trimmed);
    return trimmed;
  }

  Future<List<String>> removeRecentSearch(String query) async {
    final list = getRecentSearches()..remove(query);
    await Prefs.recentSearches.set(list);
    return list;
  }

  Future<void> clearRecentSearches() => Prefs.recentSearches.clear();

  // ---------------- Favourites ----------------

  Set<int> getFavouriteIds() {
    return Prefs.favouriteIds.get().map(int.tryParse).whereType<int>().toSet();
  }

  Future<void> saveFavouriteIds(Set<int> ids) async {
    await Prefs.favouriteIds.set(ids.map((e) => e.toString()).toList());
  }
}
