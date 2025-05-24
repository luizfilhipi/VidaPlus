import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import './validators.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) async {
    // Validate inputs
    final emailError = EmailValidator.validate(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      throw ValidationException(passwordError);
    }

    // Proceed with authentication
    return repository.login(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) async {
    // Validate inputs
    final emailError = EmailValidator.validate(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      throw ValidationException(passwordError);
    }

    // Proceed with registration
    return repository.register(email, password);
  }
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
