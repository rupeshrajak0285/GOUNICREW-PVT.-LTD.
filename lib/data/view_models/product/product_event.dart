part of 'product_bloc.dart';

abstract class ProductEvent {}

/// Loads the first page. Used for the first load, retry and pull-to-refresh.
/// When [completer] is passed it's treated as a refresh: the current list stays
/// on screen and the completer tells the RefreshIndicator when to stop spinning.
class FetchProductsEvent extends ProductEvent {
  final Completer<void>? completer;

  FetchProductsEvent({this.completer});

  bool get isRefresh => completer != null;
}

/// Next page when user scrolls to the bottom
class LoadMoreProductsEvent extends ProductEvent {}

/// Fired (debounced) while the user types in the search box
class SearchProductsEvent extends ProductEvent {
  final String query;

  SearchProductsEvent(this.query);
}

/// Fired when user presses search on keyboard or taps a result,
/// that's when we know the keyword is "final" and worth saving.
class SaveRecentSearchEvent extends ProductEvent {
  final String query;

  SaveRecentSearchEvent(this.query);
}

class RemoveRecentSearchEvent extends ProductEvent {
  final String query;

  RemoveRecentSearchEvent(this.query);
}

class ClearRecentSearchesEvent extends ProductEvent {}

class ToggleFavouriteEvent extends ProductEvent {
  final int productId;

  ToggleFavouriteEvent(this.productId);
}
