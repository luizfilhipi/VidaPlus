import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/validators.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  late final SignInUseCase _signInUseCase;
  late final SignUpUseCase _signUpUseCase;

  AuthController(this.authRepository) {
    _signInUseCase = SignInUseCase(authRepository);
    _signUpUseCase = SignUpUseCase(authRepository);
  }

  var user = Rxn<UserEntity>();
  var isLoading = false.obs;
  var error = ''.obs;

  String? validateEmail(String? value) => EmailValidator.validate(value);
  String? validatePassword(String? value) => PasswordValidator.validate(value);
  Future<bool> login(String email, String password) async {
    try {
      error.value = '';
      isLoading.value = true;
      user.value = await _signInUseCase.execute(email, password);
      return true; // Login successful
    } catch (e) {
      error.value = e is ValidationException ? e.message : 'Erro ao fazer login';
      return false; // Login failed
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      error.value = '';
      isLoading.value = true;
      user.value = await _signUpUseCase.execute(email, password);
    } catch (e) {
      error.value = e is ValidationException ? e.message : 'Erro ao registrar';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      error.value = '';
      isLoading.value = true;
      await authRepository.logout();
      user.value = null;
    } catch (e) {
      error.value = 'Erro ao fazer logout';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      user.value = await authRepository.getCurrentUser();
    } catch (e) {
      print('Error checking current user: $e');
    }
  }
}
