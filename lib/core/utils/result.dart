sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  final String? message;

  const Success(this.data, {this.message});
}

class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  const Failure(
    this.message, {
    this.exception,
    this.stackTrace,
  });
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get message => switch (this) {
    Success<T> success => success.message,
    Failure<T> failure => failure.message,
  };

  Exception? get exception => isFailure ? (this as Failure<T>).exception : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onFailure,
  }) {
    return switch (this) {
      Success<T> success => onSuccess(success.data),
      Failure<T> failure => onFailure(failure.message),
    };
  }
} 