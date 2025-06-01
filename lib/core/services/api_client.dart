import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Dio get dio => _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
    ));

    // Add request interceptor for token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    // Add logging interceptor in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ));
    }
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Authorization header if token exists
    final token = await _secureStorage.read(key: ApiConfig.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      await _handleUnauthorized();
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    // Clear stored token and user data
    await _secureStorage.delete(key: ApiConfig.tokenKey);
    await _secureStorage.delete(key: ApiConfig.userKey);
    await _secureStorage.delete(key: ApiConfig.refreshTokenKey);
    
    // You can implement navigation to login screen here
    // Get.offAllNamed('/login'); // if using GetX
  }

  // Token management methods
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: ApiConfig.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: ApiConfig.tokenKey);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: ApiConfig.tokenKey);
  }

  Future<void> setUserData(String userData) async {
    await _secureStorage.write(key: ApiConfig.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _secureStorage.read(key: ApiConfig.userKey);
  }

  Future<void> clearUserData() async {
    await _secureStorage.delete(key: ApiConfig.userKey);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
} 