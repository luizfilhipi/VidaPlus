import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../controllers/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // Injetando o FirebaseAuth
    Get.lazyPut(() => FirebaseAuth.instance);

    // Injetando o AuthService com a dependência do FirebaseAuth
    Get.lazyPut(() => AuthService(Get.find<FirebaseAuth>()));

    // Injetando o AuthController com a dependência do AuthService
    Get.lazyPut(() => AuthController(Get.find<AuthService>()));
  }
}
