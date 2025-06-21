import '../models/user_model.dart';
import '../models/api_response.dart';

abstract class AuthRepository {
  Future<ApiResponse<LoginResponse>> login(LoginRequest request);
  Future<ApiResponse<void>> logout();
  Future<bool> isLoggedIn();
  Future<User?> getStoredUser();
  Future<bool> checkTokenValidity();
  Future<ApiResponse<User>> refreshUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final dynamic _authService; // Will be injected

  AuthRepositoryImpl(this._authService);

  @override
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      return await _authService.login(request);
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Login failed: $e',
        data: null,
      );
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      await _authService.logout();
      return ApiResponse<void>(
        success: true,
        message: 'Logout successful',
        data: null,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Logout failed: $e',
        data: null,
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _authService.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getStoredUser() async {
    try {
      return await _authService.getStoredUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> checkTokenValidity() async {
    try {
      return await _authService.checkTokenValidity();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiResponse<User>> refreshUser() async {
    try {
      final user = await _authService.refreshUser();
      return ApiResponse<User>(
        success: true,
        message: 'User refreshed successfully',
        data: user,
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to refresh user: $e',
        data: null,
      );
    }
  }
} 