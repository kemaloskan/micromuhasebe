import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String? role;
  final List<String>? permissions;
  final Company? company;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.role,
    this.permissions,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String getUserInitials() {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String getRoleDisplayName() {
    switch (role?.toLowerCase()) {
      case 'admin':
        return 'Yönetici';
      case 'manager':
        return 'Müdür';
      case 'user':
        return 'Kullanıcı';
      case 'accountant':
        return 'Muhasebeci';
      case 'sales':
        return 'Satış Temsilcisi';
      default:
        return 'Kullanıcı';
    }
  }

  bool hasPermission(String permission) {
    if (role == 'admin') return true;
    return permissions?.contains(permission) ?? false;
  }

  bool hasRole(String roleToCheck) {
    return role == roleToCheck;
  }
}

@JsonSerializable()
class Company {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  @JsonKey(name: 'tax_number')
  final String? taxNumber;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Company({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.taxNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  @JsonKey(name: 'remember_me')
  final bool rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final User user;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const LoginResponse({
    required this.token,
    required this.user,
    this.tokenType = 'Bearer',
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
} 