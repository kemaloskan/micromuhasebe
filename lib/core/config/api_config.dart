class ApiConfig {
  // Demo mode flag - set to true for offline demo
  static const bool isDemoMode = true;
  
  // API Base URL - Laravel backend URL'inizi buraya yazın
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Laravel Sanctum endpoints
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String userEndpoint = '/auth/user';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  
  // ERP Module endpoints
  static const String stockEndpoint = '/stock';
  static const String salesEndpoint = '/sales';
  static const String purchasingEndpoint = '/purchasing';
  static const String financeEndpoint = '/finance';
  
  // Stock Management endpoints
  static const String stockItemsEndpoint = '/stock/items';
  static const String stockTransactionsEndpoint = '/stock/transactions';
  static const String stockReportsEndpoint = '/stock/reports';
  static const String warehousesEndpoint = '/warehouses';
  static const String stockCategoriesEndpoint = '/stock/categories';
  
  // Sales Management endpoints
  static const String customersEndpoint = '/customers';
  static const String salesInvoicesEndpoint = '/sales/invoices';
  static const String salesOrdersEndpoint = '/sales/orders';
  static const String salesReportsEndpoint = '/sales/reports';
  
  // Purchasing Management endpoints
  static const String suppliersEndpoint = '/suppliers';
  static const String purchaseInvoicesEndpoint = '/purchasing/invoices';
  static const String purchaseOrdersEndpoint = '/purchasing/orders';
  static const String purchaseReportsEndpoint = '/purchasing/reports';
  
  // Finance Management endpoints
  static const String accountsEndpoint = '/finance/accounts';
  static const String transactionsEndpoint = '/finance/transactions';
  static const String cashFlowEndpoint = '/finance/cash-flow';
  static const String financeReportsEndpoint = '/finance/reports';
  
  // Common endpoints
  static const String companiesEndpoint = '/companies';
  static const String usersEndpoint = '/users';
  static const String rolesEndpoint = '/roles';
  static const String permissionsEndpoint = '/permissions';
  
  // Request timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  
  // API Response status codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int validationErrorCode = 422;
  static const int serverErrorCode = 500;
} 