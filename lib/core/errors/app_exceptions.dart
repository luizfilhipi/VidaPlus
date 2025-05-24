abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class AuthException extends AppException {
  AuthException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class ValidationException extends AppException {
  ValidationException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class StorageException extends AppException {
  StorageException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class NotFoundError extends AppException {
  NotFoundError(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}
