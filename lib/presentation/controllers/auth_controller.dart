import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  var user = Rxn<UserEntity>();
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      error.value = '';
      isLoading.value = true;
      user.value = await authRepository.login(email, password);
    } catch (e) {
      error.value = 'Erro ao fazer login';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      error.value = '';
      isLoading.value = true;
      user.value = await authRepository.register(email, password);
    } catch (e) {
      error.value = 'Erro ao registrar';
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
