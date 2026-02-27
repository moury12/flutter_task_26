# Daraz-style Flutter Product Listing App

A production-quality Flutter app built with **BLoC**, **Dio**, **get_it**, and **cached_network_image**.
Data is sourced in real-time from [FakeStoreAPI](https://fakestoreapi.com/).

---

## How to Run

```bash
flutter pub get
flutter run
```

### Test Credentials

| Field    | Value       |
|----------|-------------|
| Username | `johnd`     |
| Password | `m38rmF$`   |

---

## Scroll Architecture

### Why CustomScrollView owns the single vertical scroll

The home screen uses a **single `CustomScrollView`** as the sole owner of vertical scrolling.
This avoids the classic Flutter anti-pattern of nested scrollables (e.g. `ListView` inside
`SingleChildScrollView`), which causes scroll conflicts, janky gestures, and layout overflow errors.

```
CustomScrollView (single scroll owner)
  ├── SliverAppBar          → collapsible banner + search bar
  ├── SliverPersistentHeader → sticky tab bar (pinned: true)
  └── SliverFillRemaining   → tab content area (TabBarView)
```

### SliverPersistentHeader for the sticky tab bar

`SliverPersistentHeader(pinned: true, delegate: _StickyTabBarDelegate(…))` creates a header
that sticks to the top of the viewport once the `SliverAppBar` has been scrolled away.
`_StickyTabBarDelegate` defines `minExtent == maxExtent == TabBar.preferredSize.height`,
meaning the header never collapses.

### Why TabBarView uses NeverScrollableScrollPhysics

`TabBarView` is placed inside `SliverFillRemaining` **only to drive tab switching animations**.
Vertical scroll is **disabled** on it via `NeverScrollableScrollPhysics()`.
The `GridView` inside each tab also uses `NeverScrollableScrollPhysics()` + `shrinkWrap: true`
so all vertical scroll events bubble up to the owning `CustomScrollView`.

### Horizontal swipe via GestureDetector + TabController

```dart
GestureDetector(
  onHorizontalDragEnd: (details) {
    if (details.primaryVelocity! < 0) tabController.animateTo(next);
    if (details.primaryVelocity! > 0) tabController.animateTo(prev);
  },
  child: TabBarView(
    physics: NeverScrollableScrollPhysics(),
    controller: tabController,
    children: [...],
  ),
)
```

Because `TabBarView` is prevented from handling vertical scroll, horizontal drag events
are caught cleanly by the `GestureDetector` and forwarded to `TabController.animateTo()`.

---

## Tab Scroll Position Preservation

```dart
// Save before switching
_tabScrollOffsets[oldIndex] = _scrollController.offset;

// Restore after switching
_scrollController.jumpTo(_tabScrollOffsets[newIndex]);
```

A single `ScrollController` is shared across the `CustomScrollView`.  
A `Map<int, double>` stores the scroll offset for each tab.  
When `TabController.addListener` fires at the end of a tab animation (`indexIsChanging == false`),
the old offset is saved and the new tab's offset is restored with `jumpTo` (not `animateTo`
to avoid jitter).

---

## Trade-offs

| Trade-off | Reason |
|---|---|
| `jumpTo` instead of `animateTo` for scroll restoration | `animateTo` causes a visible "bounce" during tab switching; `jumpTo` is instant and invisible |
| User ID hardcoded to `1` | FakeStoreAPI's JWT token is opaque and does not encode the user ID |
| Three separate `ProductBloc` instances | Allows each tab to load & cache independently; switching tabs is instant after first load |
| `TabBarView` swipe sensitivity vs. scroll conflict | `NeverScrollableScrollPhysics` on `TabBarView` completely delegates swipe detection to `GestureDetector`, ensuring no axis conflict |

---

## Folder Structure

```
lib/
├── core/
│   ├── constants/    app_constants.dart
│   ├── network/      dio_client.dart
│   └── di/           injection.dart
├── data/
│   ├── models/       product_model.dart, user_model.dart
│   └── repositories/ product_repository.dart, auth_repository.dart
├── presentation/
│   ├── auth/
│   │   ├── bloc/     auth_bloc.dart, auth_event.dart, auth_state.dart
│   │   └── screens/  login_screen.dart
│   ├── home/
│   │   ├── bloc/     product_bloc.dart, product_event.dart, product_state.dart
│   │   └── screens/  home_screen.dart
│   └── profile/
│       └── screens/  profile_screen.dart
└── main.dart
```

## API Endpoints

| Purpose | Endpoint |
|---|---|
| Login | `POST /auth/login` |
| All products | `GET /products` |
| Electronics | `GET /products/category/electronics` |
| Men's clothing | `GET /products/category/men's clothing` |
| User profile | `GET /users/1` |
