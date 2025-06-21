import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Demo veriler - gerçek uygulamada kaldırın
    _emailController.text = AppConstants.adminEmail;
    _passwordController.text = AppConstants.demoPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    // Clear previous errors
    authProvider.clearError();

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;

    if (success) {
      // Navigation is handled by AuthWrapper in main.dart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(SuccessMessages.loginSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error message
      final errorMessage = authProvider.errorMessage ?? ErrorMessages.invalidCredentials;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 64,
                    color: Color(0xFF696CFF),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF566A7F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hesabınıza giriş yapın',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA5A3AE),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Demo Accounts Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7FF).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF696CFF).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF696CFF), size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Demo Mode - Offline Çalışma',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF696CFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tüm hesaplar için şifre: ${AppConstants.demoPassword}',
                          style: const TextStyle(
                            fontSize: 12, 
                            color: Color(0xFF566A7F), 
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '• ${AppConstants.adminEmail} (Yönetici)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF566A7F)),
                        ),
                        const Text(
                          '• ${AppConstants.managerEmail} (Müdür)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF566A7F)),
                        ),
                        const Text(
                          '• ${AppConstants.userEmail} (Kullanıcı)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF566A7F)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ErrorMessages.emailRequired;
                      }
                      if (!value.contains('@')) {
                        return ErrorMessages.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ErrorMessages.passwordRequired;
                      }
                      if (value.length < AppConstants.minPasswordLength) {
                        return ErrorMessages.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Beni hatırla'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: const Color(0xFF696CFF),
                          foregroundColor: Colors.white,
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Giriş Yap'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 