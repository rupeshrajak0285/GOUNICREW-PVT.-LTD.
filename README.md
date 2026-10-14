# ShopEase – Product Listing App

A Flutter product listing app built on the [DummyJSON Products API](https://dummyjson.com/docs/products).
It shows a product grid with search, pull-to-refresh, infinite scroll and a detail page, and it
keeps working offline by saving data in local storage.

## Features

| Requirement | How it's done |
|---|---|
| Fetch products from API | `GET /products` with `limit`/`skip` paging and `select` so only the needed fields come back |
| Image, title & price | `ProductCard` shows the image, category, title, price, original (struck-out) price, discount badge and rating |
| Loading indicator | Skeleton grid on first load, a small spinner at the bottom while the next page loads, and a placeholder on each image |
| Error state | Full-screen error with **Try again**, readable messages from `AppInterceptor` (no internet, timeout, 404, 500…), and **tap to retry** if a later page fails |
| Search | Debounced (500 ms) search through `GET /products/search?q=`. Late responses are ignored so results never flicker back to an old query |
| Product detail | Swipeable image gallery with a Hero animation, price and discount, stock status, description, shipping/warranty/return info and reviews |
| Pull-to-refresh | `RefreshIndicator`. The list stays on screen while refreshing, and if the refresh fails you get a toast and the old data stays |

**Extra: local storage (SharedPreferences)**
- **Offline cache:** the first page is saved after every successful load. If the API fails, saved products are shown with an *"You're offline"* banner, and search filters the saved list locally.
- **Recent searches:** the last 6 keywords are shown as chips when the search box is focused. Tap a chip to search again, or remove chips one at a time or all at once.
- **Favourites / wishlist:** the heart on a card or the detail page is saved locally and kept after the app restarts. A badge in the app bar shows the count.
- Images are cached on disk by `cached_network_image`.

## State management – Bloc

I used **flutter_bloc** with Equatable states:
- It keeps UI and business logic apart. Screens only send events and draw state, so the logic can be tested without widgets (see `test/view_models`).
- One `PageStatus` enum (`initial / loading / success / failure`) drives the whole screen, so you can't end up with a mix of loading and error at the same time.
- Paging has its own flags (`isLoadingMore`, `loadMoreFailed`), so loading page 2 never replaces the grid with a loader.
- Repositories are provided once with `MultiRepositoryProvider` and passed into the bloc through its constructor. That makes it easy to swap in a fake repository in tests.

## Folder structure

```
lib/
├── main.dart                     # init prefs + dio, repositories, MaterialApp
├── common_libraries.dart         # single barrel import used by every file
├── constants/                    # AppColor, AppDimens, AppStrings
├── core/
│   ├── api_urls/                 # base url + endpoints
│   ├── base/                     # BaseRepository (shared get/post)
│   ├── exception/                # custom DioExceptions with user-friendly messages
│   ├── services/                 # ApiClientService (Dio singleton), AppInterceptor
│   └── utils/                    # PageStatus, AppToaster, AppUtils, Debouncer
├── data/
│   ├── models/                   # ProductModel, ReviewModel, ProductResponseModel
│   ├── repositories/             # ProductRepository (API calls)
│   ├── storage/                  # Prefs wrapper, PrefKeys, ProductLocalStorage
│   └── view_models/product/      # ProductBloc + events + state
├── global_widgets/widgets/       # reusable: loader, network image, message view,
│                                 # search field, price, rating, favourite button
└── presentation/features/
    ├── product_list/             # list screen + widgets (card, skeleton, footer,
    │                             # recent searches, offline banner)
    └── product_detail/           # detail screen + widgets (gallery, stock chip,
                                  # highlight tile, review card)
test/
├── models/                       # json parsing, toJson round trip
├── storage/                      # cache, recent searches, favourites
└── view_models/                  # bloc: load, paging, search, offline, refresh, favourite
```

## Setup

**Requirements:** Flutter 3.32+ (Dart 3.8+), tested on Flutter 3.44 / Dart 3.12. You also need Android Studio or Xcode to run on a device. No API key is needed.

```bash
git clone <repo-url>
```

```bash
cd product_listing_app
```

```bash
flutter pub get
```

Run on a connected device or emulator:

```bash
flutter run
```

Run the unit tests:

```bash
flutter test
```

Build a release APK:

```bash
flutter build apk --release
```

## Packages

| Package | Why |
|---|---|
| `flutter_bloc`, `equatable` | State management and value equality for states |
| `dio` | HTTP client with interceptors, timeouts and typed errors |
| `shared_preferences` | Local storage for the offline cache, recent searches and favourites |
| `cached_network_image` | Image caching with placeholder and error widgets |

## Screenshots

| Product list | Search | Recent searches |
|---|---|---|
| ![list](screenshots/01_product_list.jpg) | ![search](screenshots/02_search.jpg) | ![recent](screenshots/05_recent_searches.jpg) |

| Product detail | Detail – reviews | Offline (cached data) | Error state |
|---|---|---|---|
| ![detail](screenshots/03_product_detail.jpg) | ![reviews](screenshots/04_product_detail_reviews.jpg) | ![offline](screenshots/06_offline_cache.jpg) | ![error](screenshots/07_error_state.jpg) |

## Notes

- DummyJSON only returns the discounted price, so the struck-out "original" price is worked out from `discountPercentage`.
- The detail screen uses the product passed from the list, so it doesn't make another API call and opens instantly.
- Search results are not cached because they change with every keyword. Only the main list is cached.
