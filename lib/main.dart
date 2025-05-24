import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import './firebase_options.dart';
import './presentation/bindings/auth_bindings.dart';
import './presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await initializeDependencies();
  runApp(const MyApp());
}

Future<void> initializeDependencies() async {
  final bindings = AuthBindings();
  bindings.dependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VidaPlus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(controller: Get.find<AuthController>()),
    );
  }
}