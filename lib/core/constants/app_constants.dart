class AppConstants {
  // App Info
  static const String appName = 'Webfinans ERP';
  static const String appDescription = 'Modern ERP uygulaması';
  
  // Colors
  static const String primaryColorHex = '#696CFF';
  static const String secondaryColorHex = '#566A7F';
  static const String greyColorHex = '#A5A3AE';
  
  // Demo Users
  static const String adminEmail = 'admin@example.com';
  static const String managerEmail = 'manager@example.com';
  static const String userEmail = 'user@example.com';
  static const String demoPassword = 'password';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // API Endpoints
  static const String baseUrl = 'https://api.webfinans.com';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshEndpoint = '/auth/refresh';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxEmailLength = 255;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
}

class ErrorMessages {
  static const String networkError = 'İnternet bağlantısı hatası';
  static const String serverError = 'Sunucu hatası';
  static const String timeoutError = 'İstek zaman aşımına uğradı';
  static const String unauthorizedError = 'Yetkisiz erişim';
  static const String forbiddenError = 'Erişim yasak';
  static const String notFoundError = 'Kaynak bulunamadı';
  static const String validationError = 'Giriş verileri hatalı';
  static const String unknownError = 'Bilinmeyen hata oluştu';
  
  // Auth Errors
  static const String invalidCredentials = 'Geçersiz kullanıcı adı veya şifre';
  static const String tokenExpired = 'Oturum süresi doldu';
  static const String emailRequired = 'E-posta adresi gerekli';
  static const String passwordRequired = 'Şifre gerekli';
  static const String invalidEmail = 'Geçerli bir e-posta adresi girin';
  static const String passwordTooShort = 'Şifre en az 6 karakter olmalı';
}

class SuccessMessages {
  static const String loginSuccess = 'Giriş başarılı!';
  static const String logoutSuccess = 'Başarıyla çıkış yapıldı';
  static const String updateSuccess = 'Güncelleme başarılı';
  static const String deleteSuccess = 'Silme işlemi başarılı';
  static const String saveSuccess = 'Kaydetme işlemi başarılı';
} 