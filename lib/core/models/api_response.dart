import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  // Success response factory
  factory ApiResponse.success({
    required String message,
    Map<String, dynamic>? data,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      meta: meta,
    );
  }

  // Error response factory
  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
    Map<String, dynamic>? data,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
      data: data,
    );
  }
}

@JsonSerializable()
class PaginatedData {
  final List<Map<String, dynamic>> data;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;
  final int from;
  final int to;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  const PaginatedData({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginatedData.fromJson(Map<String, dynamic> json) => _$PaginatedDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedDataToJson(this);

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
} 