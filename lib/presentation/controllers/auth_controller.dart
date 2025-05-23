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
      isLoading.value = true;
      user.value = await authRepository.register(email, password);
    } catch (e) {
      error.value = 'Erro ao registrar';
    } finally {
      isLoading.value = false;
    }
  }
}
