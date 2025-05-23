import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_vidaplus/core/theme/app_themes.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/repositories_impl/auth_repository_impl.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/pages/login_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepository = AuthRepositoryImpl(FirebaseAuthDataSource());
  final authController = AuthController(authRepository);

  runApp(MyApp(controller: authController));
}

class MyApp extends StatelessWidget {
  final AuthController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vida+',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Alterna conforme o SO
      home: LoginPage(controller: controller),
    );
  }
}