class AppConstants {
  AppConstants._();

  // Base URL
  static const String baseUrl = 'https://fakestoreapi.com';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';

  // Product endpoints
  static const String productsEndpoint = '/products';
  static const String productsByCategoryEndpoint = '/products/category';

  // User endpoints
  static const String usersEndpoint = '/users';

  // Hardcoded user ID (FakeStoreAPI JWT doesn't return user id)
  static const int hardcodedUserId = 1;

  // Tabs
  static const List<String> tabLabels = [
    'All',
    'Electronics',
    "Men's Clothing",
  ];
  static const List<String?> tabCategories = [
    null,
    'electronics',
    "men's clothing",
  ];

  // UI
  static const double sliverAppBarExpandedHeight = 180.0;
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 12.0;
  static const double cardBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double productImageHeight = 160.0;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.68;
  static const double gridMainSpacing = 12.0;
  static const double gridCrossSpacing = 12.0;

  // Shimmer
  static const int shimmerItemCount = 6;

  // Swipe velocity threshold
  static const double swipeVelocityThreshold = 0.0;

  // Test credentials (for README / convenience)
  static const String testUsername = 'johnd';
  static const String testPassword = 'm38rmF\$';
}
