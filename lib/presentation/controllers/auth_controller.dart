import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/errors/validation_exception.dart';
import '../../domain/usecases/validators.dart';
import '../../core/services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final Rx<UserEntity?> user = Rx<UserEntity?>(null);

  AuthController(this._authService) {
    // Check initial auth state
    _authService.authStateChanges().listen((user) {
      this.user.value = user;
      if (user != null) {
        Get.offAllNamed(AppRoutes.habits); // Redireciona para a página de tracking após login
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  var isLoading = false.obs;
  var error = ''.obs;

  String? validateEmail(String? value) => EmailValidator.validate(value);
  String? validatePassword(String? value) => PasswordValidator.validate(value);
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (email.isEmpty || password.isEmpty) {
        error.value = 'Email e senha são obrigatórios';
        return false;
      }

      final emailError = validateEmail(email);
      if (emailError != null) {
        error.value = emailError;
        return false;
      }

      final passwordError = validatePassword(password);
      if (passwordError != null) {
        error.value = passwordError;
        return false;
      }

      user.value = await _authService.signIn(email, password);
      return true;
    } catch (e) {
      error.value = e is ValidationException ? e.message : 'Erro ao fazer login';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      error.value = '';
      isLoading.value = true;
      user.value = await _authService.signUp(email, password);
    } catch (e) {
      error.value = e is ValidationException ? e.message : 'Erro ao registrar';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Primeiro limpa o estado do usuário
      user.value = null;

      // Depois faz o signOut
      await _authService.signOut();

      // A navegação será feita automaticamente pelo listener do authStateChanges
    } catch (e) {
      error.value = 'Erro ao fazer logout';
      print('Erro ao fazer logout: $e');
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
      user.value = await _authService.getCurrentUser();
    } catch (e) {
      print('Error checking current user: $e');
    }
  }
}
