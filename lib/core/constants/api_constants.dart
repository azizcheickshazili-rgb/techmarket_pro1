/// Centralised constants for the DummyJSON REST backend.
///
/// Keeping every endpoint in one place avoids magic strings scattered
/// across data sources and makes the API surface easy to audit.
abstract final class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  // Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  // Products
  static const String products = '/products';
  static const String productCategories = '/products/categories';
  static String productById(int id) => '/products/$id';
  static String productsByCategory(String category) =>
      '/products/category/$category';
  static const String productSearch = '/products/search';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const int defaultPageLimit = 20;
}
