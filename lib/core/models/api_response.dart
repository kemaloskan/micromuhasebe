class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  // Success response factory
  factory ApiResponse.success({
    required String message,
    T? data,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse<T>(
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
    T? data,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      data: data,
    );
  }
}

class PaginatedData {
  final List<Map<String, dynamic>> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final String? nextPageUrl;
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

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
} 