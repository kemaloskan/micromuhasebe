import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _setLoading(true);
    try {
      if (ApiConfig.isDemoMode) {
        // Demo mode - check for stored demo user
        // For now, just skip initialization in demo mode
        _setLoading(false);
        return;
      }

      // Check if user is already logged in
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        // Try to get stored user data
        final storedUser = await _authService.getStoredUser();
        if (storedUser != null) {
          // Verify token is still valid
          final tokenValid = await _authService.checkTokenValidity();
          if (tokenValid) {
            _currentUser = storedUser;
            _isAuthenticated = true;
            _clearError();
          } else {
            // Token expired, logout
            await logout();
          }
        }
      }
    } catch (e) {
      _setError('Kullanıcı durumu kontrol edilirken hata oluştu');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    _setLoading(true);
    _clearError();

    try {
      if (ApiConfig.isDemoMode) {
        return await _handleDemoLogin(email, password);
      }

      final loginRequest = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final response = await _authService.login(loginRequest);

      if (response.success && response.data != null) {
        final loginResponse = LoginResponse.fromJson(response.data!);
        _currentUser = loginResponse.user;
        _isAuthenticated = true;
        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      _setError('Giriş yapılırken beklenmeyen bir hata oluştu: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> _handleDemoLogin(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Simple demo users without complex JSON parsing
      User? demoUser;
      
      switch (email) {
        case 'admin@example.com':
          demoUser = User(
            id: 1,
            name: 'Admin User',
            email: 'admin@example.com',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
            role: 'admin',
            permissions: ['*'],
            company: Company(
              id: 1,
              name: 'Demo Şirket',
              address: 'İstanbul, Türkiye',
              phone: '+90 555 123 4567',
              email: 'info@demosirket.com',
              taxNumber: '1234567890',
              createdAt: DateTime(2024, 1, 1),
              updatedAt: DateTime(2024, 1, 1),
            ),
          );
          break;
          
        case 'manager@example.com':
          demoUser = User(
            id: 2,
            name: 'Manager User',
            email: 'manager@example.com',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
            role: 'manager',
            permissions: ['stock', 'sales', 'purchasing'],
            company: Company(
              id: 1,
              name: 'Demo Şirket',
              address: 'İstanbul, Türkiye',
              phone: '+90 555 123 4567',
              email: 'info@demosirket.com',
              taxNumber: '1234567890',
              createdAt: DateTime(2024, 1, 1),
              updatedAt: DateTime(2024, 1, 1),
            ),
          );
          break;
          
        case 'user@example.com':
          demoUser = User(
            id: 3,
            name: 'Regular User',
            email: 'user@example.com',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
            role: 'user',
            permissions: ['stock'],
            company: Company(
              id: 1,
              name: 'Demo Şirket',
              address: 'İstanbul, Türkiye',
              phone: '+90 555 123 4567',
              email: 'info@demosirket.com',
              taxNumber: '1234567890',
              createdAt: DateTime(2024, 1, 1),
              updatedAt: DateTime(2024, 1, 1),
            ),
          );
          break;
      }

      if (demoUser != null && password == 'password') {
        _currentUser = demoUser;
        _isAuthenticated = true;
        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError('Geçersiz kullanıcı adı veya şifre');
        return false;
      }
    } catch (e) {
      _setError('Demo giriş hatası: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      if (!ApiConfig.isDemoMode) {
        await _authService.logout();
      }
    } catch (e) {
      // Even if API call fails, clear local state
    } finally {
      _currentUser = null;
      _isAuthenticated = false;
      _clearError();
      _setLoading(false);
    }
  }

  Future<void> refreshUser() async {
    if (!_isAuthenticated) return;

    if (ApiConfig.isDemoMode) {
      // In demo mode, no need to refresh
      return;
    }

    try {
      final response = await _authService.getCurrentUser();
      if (response.success && response.data != null) {
        _currentUser = User.fromJson(response.data!);
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently or show message
    }
  }

  bool hasPermission(String permission) {
    if (!_isAuthenticated || _currentUser == null) return false;
    return _currentUser!.hasPermission(permission);
  }

  bool hasRole(String role) {
    if (!_isAuthenticated || _currentUser == null) return false;
    return _currentUser!.hasRole(role);
  }

  bool hasModuleAccess(String module) {
    if (!_isAuthenticated || _currentUser == null) return false;
    
    // Check based on user role and permissions
    final userRole = _currentUser!.role?.toLowerCase();
    
    switch (userRole) {
      case 'admin':
        return true; // Admin has access to everything
      case 'manager':
        return ['Stok Yönetimi', 'Satış Yönetimi', 'Satın Alma Yönetimi', 'Finans Yönetimi']
            .contains(module);
      case 'accountant':
        return ['Finans Yönetimi', 'Satın Alma Yönetimi'].contains(module);
      case 'sales':
        return ['Satış Yönetimi', 'Stok Yönetimi'].contains(module);
      case 'user':
        return ['Stok Yönetimi'].contains(module);
      default:
        return false;
    }
  }

  String getUserInitials() {
    if (_currentUser == null) return 'U';
    return _currentUser!.getUserInitials();
  }

  String getRoleDisplayName() {
    if (_currentUser == null) return 'Kullanıcı';
    return _currentUser!.getRoleDisplayName();
  }

  String? get userName => _currentUser?.name;
  String? get userEmail => _currentUser?.email;
  String? get userRole => _currentUser?.role;
  List<String>? get userPermissions => _currentUser?.permissions;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  // Session timeout check (call this periodically or on app resume)
  Future<void> checkSession() async {
    if (_isAuthenticated && !ApiConfig.isDemoMode) {
      final tokenValid = await _authService.checkTokenValidity();
      if (!tokenValid) {
        await logout();
      }
    }
  }
} 