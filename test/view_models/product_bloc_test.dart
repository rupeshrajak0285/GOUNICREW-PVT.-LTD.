import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/common_libraries.dart';

import '../test_helpers.dart';

void main() {
  late FakeProductRepository repository;
  late ProductLocalStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Prefs.init();
    repository = FakeProductRepository();
    storage = ProductLocalStorage();
  });

  ProductBloc buildBloc() => ProductBloc(repository: repository, localStorage: storage);

  /// waits till the bloc is done with the current load
  Future<ProductState> settled(ProductBloc bloc) {
    return bloc.stream.firstWhere(
      (s) => !s.pageStatus.isLoading && !s.pageStatus.isInitial && !s.isLoadingMore,
    );
  }

  test('loads first page on start and caches it', () async {
    final bloc = buildBloc();
    final state = await settled(bloc);

    expect(state.pageStatus, PageStatus.success);
    expect(state.products.length, ProductRepository.pageSize);
    expect(storage.getCachedProducts().length, ProductRepository.pageSize);
    await bloc.close();
  });

  test('load more appends next page and stops at the end', () async {
    final bloc = buildBloc();
    await settled(bloc);

    bloc.add(LoadMoreProductsEvent());
    final state = await settled(bloc);

    expect(state.products.length, 30);
    expect(state.hasReachedEnd, isTrue);
    await bloc.close();
  });

  test('shows error when api fails and nothing is cached', () async {
    repository.shouldFail = true;
    final bloc = buildBloc();
    final state = await settled(bloc);

    expect(state.pageStatus, PageStatus.failure);
    expect(state.errorMessage, isNotEmpty);
    await bloc.close();
  });

  test('falls back to cached products when offline', () async {
    await storage.cacheProducts(fakeProducts(5));
    repository.shouldFail = true;

    final bloc = buildBloc();
    final state = await settled(bloc);

    expect(state.pageStatus, PageStatus.success);
    expect(state.isOfflineData, isTrue);
    expect(state.products.length, 5);
    await bloc.close();
  });

  test('search calls the search api', () async {
    final bloc = buildBloc();
    await settled(bloc);

    bloc.add(SearchProductsEvent('phone'));
    final state = await settled(bloc);

    expect(repository.searchedQueries, ['phone']);
    expect(state.products.single.title, 'Result for phone');
    await bloc.close();
  });

  test('refresh failure keeps the current list', () async {
    final bloc = buildBloc();
    await settled(bloc);

    repository.shouldFail = true;
    final completer = Completer<void>();
    bloc.add(FetchProductsEvent(completer: completer));

    await expectLater(completer.future, throwsA(isA<String>()));
    expect(bloc.state.products.length, ProductRepository.pageSize);
    await bloc.close();
  });

  test('toggle favourite saves to local storage', () async {
    final bloc = buildBloc();
    await settled(bloc);

    bloc.add(ToggleFavouriteEvent(3));
    await bloc.stream.firstWhere((s) => s.favouriteIds.contains(3));

    expect(storage.getFavouriteIds(), {3});
    await bloc.close();
  });
}
