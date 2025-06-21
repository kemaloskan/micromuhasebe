import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/result.dart';
import '../constants/app_constants.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<User>> execute({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty) {
        return const Failure(ErrorMessages.emailRequired);
      }
      
      if (password.isEmpty) {
        return const Failure(ErrorMessages.passwordRequired);
      }
      
      if (!email.contains('@')) {
        return const Failure(ErrorMessages.invalidEmail);
      }
      
      if (password.length < AppConstants.minPasswordLength) {
        return const Failure(ErrorMessages.passwordTooShort);
      }

      // Create login request
      final request = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      // Execute login
      final response = await _repository.login(request);

      if (response.success && response.data != null) {
        return Success(
          response.data!.user,
          message: SuccessMessages.loginSuccess,
        );
      } else {
        return Failure(response.message);
      }
    } catch (e, stackTrace) {
      return Failure(
        ErrorMessages.unknownError,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void>> execute() async {
    try {
      final response = await _repository.logout();
      
      if (response.success) {
        return const Success(
          null,
          message: SuccessMessages.logoutSuccess,
        );
      } else {
        return Failure(response.message);
      }
    } catch (e, stackTrace) {
      return Failure(
        ErrorMessages.unknownError,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}

class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<Result<User?>> execute() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      
      if (!isLoggedIn) {
        return const Success(null);
      }

      final user = await _repository.getStoredUser();
      
      if (user == null) {
        return const Success(null);
      }

      // Check if token is still valid
      final tokenValid = await _repository.checkTokenValidity();
      
      if (!tokenValid) {
        // Token expired, logout
        await _repository.logout();
        return const Failure(ErrorMessages.tokenExpired);
      }

      return Success(user);
    } catch (e, stackTrace) {
      return Failure(
        ErrorMessages.unknownError,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}

class RefreshUserUseCase {
  final AuthRepository _repository;

  RefreshUserUseCase(this._repository);

  Future<Result<User>> execute() async {
    try {
      final response = await _repository.refreshUser();
      
      if (response.success && response.data != null) {
        return Success(
          response.data!,
          message: SuccessMessages.updateSuccess,
        );
      } else {
        return Failure(response.message);
      }
    } catch (e, stackTrace) {
      return Failure(
        ErrorMessages.unknownError,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
} 