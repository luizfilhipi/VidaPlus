import 'package:get/get.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(
      FirebaseAuthRepository(),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(Get.find<AuthRepository>()),
      permanent: true,
    );
  }
}
