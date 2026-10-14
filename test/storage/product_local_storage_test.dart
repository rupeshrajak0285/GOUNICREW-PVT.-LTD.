import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/common_libraries.dart';

import '../test_helpers.dart';

void main() {
  late ProductLocalStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Prefs.init();
    storage = ProductLocalStorage();
  });

  test('caches and reads products back', () async {
    await storage.cacheProducts(fakeProducts(3));

    expect(storage.getCachedProducts().length, 3);
    expect(storage.getLastSyncedAt(), isNotNull);
  });

  test('recent searches: newest first, no duplicates, max 6', () async {
    for (final word in ['phone', 'laptop', 'Phone', 'a', 'b', 'c', 'd', 'e']) {
      await storage.addRecentSearch(word);
    }

    final list = storage.getRecentSearches();
    expect(list.first, 'e');
    expect(list.length, 6);
    expect(list.where((e) => e.toLowerCase() == 'phone').length, 1);
  });

  test('favourite ids are saved', () async {
    await storage.saveFavouriteIds({1, 5});
    expect(storage.getFavouriteIds(), {1, 5});
  });
}
