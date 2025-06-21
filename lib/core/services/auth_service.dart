import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Demo users for offline mode
  final Map<String, Map<String, dynamic>> _demoUsers = {
    'admin@example.com': {
      'id': 1,
      'name': 'Admin User',
      'email': 'admin@example.com',
      'email_verified_at': null,
      'role': 'admin',
      'permissions': ['*'],
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-01T00:00:00.000Z',
      'company': {
        'id': 1,
        'name': 'Demo Şirket',
        'address': 'İstanbul, Türkiye',
        'phone': '+90 555 123 4567',
        'email': 'info@demosirket.com',
        'tax_number': '1234567890',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      }
    },
    'manager@example.com': {
      'id': 2,
      'name': 'Manager User',
      'email': 'manager@example.com',
      'email_verified_at': null,
      'role': 'manager',
      'permissions': ['stock', 'sales', 'purchasing'],
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-01T00:00:00.000Z',
      'company': {
        'id': 1,
        'name': 'Demo Şirket',
        'address': 'İstanbul, Türkiye',
        'phone': '+90 555 123 4567',
        'email': 'info@demosirket.com',
        'tax_number': '1234567890',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      }
    },
    'user@example.com': {
      'id': 3,
      'name': 'Regular User',
      'email': 'user@example.com',
      'email_verified_at': null,
      'role': 'user',
      'permissions': ['stock'],
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-01T00:00:00.000Z',
      'company': {
        'id': 1,
        'name': 'Demo Şirket',
        'address': 'İstanbul, Türkiye',
        'phone': '+90 555 123 4567',
        'email': 'info@demosirket.com',
        'tax_number': '1234567890',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      }
    },
  };

  Future<ApiResponse> login(LoginRequest loginRequest) async {
    if (ApiConfig.isDemoMode) {
      return _handleDemoLogin(loginRequest);
    }

    try {
      // First, get CSRF cookie for Laravel
      await _getCsrfCookie();

      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        data: loginRequest.toJson(),
      );

      if (response.statusCode == ApiConfig.successCode) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final loginResponse = LoginResponse.fromJson(responseData['data']);
          
          // Store token and user data
          await _apiClient.setToken(loginResponse.token);
          await _apiClient.setUserData(jsonEncode(loginResponse.user.toJson()));

          return ApiResponse.success(
            message: responseData['message'] ?? 'Giriş başarılı',
            data: responseData['data'],
          );
        } else {
          return ApiResponse.error(
            message: responseData['message'] ?? 'Giriş başarısız',
            errors: responseData['errors'],
          );
        }
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Giriş başarısız',
          errors: response.data['errors'],
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Beklenmeyen bir hata oluştu: $e',
      );
    }
  }

  Future<ApiResponse> _handleDemoLogin(LoginRequest loginRequest) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final email = loginRequest.email;

      if (_demoUsers.containsKey(email)) {
        final userData = _demoUsers[email]!;
        
        // Create user from demo data
        final user = User.fromJson(userData);
        
        final loginResponse = LoginResponse(
          token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          user: user,
          tokenType: 'Bearer',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );

        // Store token and user data
        await _apiClient.setToken(loginResponse.token);
        await _apiClient.setUserData(jsonEncode(loginResponse.user.toJson()));

        return ApiResponse.success(
          message: 'Demo giriş başarılı',
          data: loginResponse.toJson(),
        );
      } else {
        return ApiResponse.error(
          message: 'Geçersiz kullanıcı adı veya şifre',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Demo login hatası: $e',
      );
    }
  }

  Future<ApiResponse> logout() async {
    if (ApiConfig.isDemoMode) {
      // Clear local storage
      await _apiClient.clearAll();
      return ApiResponse.success(
        message: 'Demo çıkış başarılı',
      );
    }

    try {
      await _apiClient.post(ApiConfig.logoutEndpoint);
      
      // Clear local storage
      await _apiClient.clearAll();

      return ApiResponse.success(
        message: 'Çıkış başarılı',
      );
    } on DioException catch (e) {
      // Even if the API call fails, clear local storage
      await _apiClient.clearAll();
      return _handleDioError(e);
    } catch (e) {
      await _apiClient.clearAll();
      return ApiResponse.error(
        message: 'Çıkış yapılırken hata oluştu: $e',
      );
    }
  }

  Future<ApiResponse> getCurrentUser() async {
    if (ApiConfig.isDemoMode) {
      final userData = await _apiClient.getUserData();
      if (userData != null) {
        return ApiResponse.success(
          message: 'Demo kullanıcı bilgileri alındı',
          data: jsonDecode(userData),
        );
      } else {
        return ApiResponse.error(
          message: 'Demo kullanıcı bilgileri bulunamadı',
        );
      }
    }

    try {
      final response = await _apiClient.get(ApiConfig.userEndpoint);

      if (response.statusCode == ApiConfig.successCode) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final user = User.fromJson(responseData['data']);
          
          // Update stored user data
          await _apiClient.setUserData(jsonEncode(user.toJson()));

          return ApiResponse.success(
            message: 'Kullanıcı bilgileri alındı',
            data: responseData['data'],
          );
        } else {
          return ApiResponse.error(
            message: responseData['message'] ?? 'Kullanıcı bilgileri alınamadı',
          );
        }
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Kullanıcı bilgileri alınamadı',
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Kullanıcı bilgileri alınırken hata oluştu: $e',
      );
    }
  }

  Future<User?> getStoredUser() async {
    try {
      final userData = await _apiClient.getUserData();
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> checkTokenValidity() async {
    if (ApiConfig.isDemoMode) {
      final token = await _apiClient.getToken();
      return token != null && token.isNotEmpty;
    }

    try {
      final response = await getCurrentUser();
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<void> _getCsrfCookie() async {
    try {
      // Laravel Sanctum requires CSRF cookie for SPA authentication
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      await _apiClient.get('$baseUrl/sanctum/csrf-cookie');
    } catch (e) {
      // Ignore CSRF cookie errors, not all setups require this
    }
  }

  ApiResponse _handleDioError(DioException e) {
    String message = 'Bir hata oluştu';
    Map<String, dynamic>? errors;

    switch (e.response?.statusCode) {
      case ApiConfig.unauthorizedCode:
        message = 'Yetkilendirme hatası. Lütfen tekrar giriş yapın.';
        break;
      case ApiConfig.forbiddenCode:
        message = 'Bu işlem için yetkiniz bulunmuyor.';
        break;
      case ApiConfig.notFoundCode:
        message = 'İstenen kaynak bulunamadı.';
        break;
      case ApiConfig.validationErrorCode:
        message = 'Doğrulama hatası';
        errors = e.response?.data['errors'];
        break;
      case ApiConfig.serverErrorCode:
        message = 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
        break;
      default:
        if (e.type == DioExceptionType.connectionTimeout) {
          message = 'Bağlantı zaman aşımına uğradı.';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          message = 'Yanıt alma zaman aşımına uğradı.';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'İnternet bağlantınızı kontrol edin.';
        } else {
          message = e.response?.data['message'] ?? message;
        }
    }

    return ApiResponse.error(
      message: message,
      errors: errors,
    );
  }
} 