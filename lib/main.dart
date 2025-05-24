import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import './firebase_options.dart';
import './presentation/bindings/auth_bindings.dart';
import './presentation/bindings/habit_bindings.dart';
import './presentation/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await initializeDependencies();
  runApp(const MyApp());
}

Future<void> initializeDependencies() async {
  // Initialize Auth dependencies
  final authBindings = AuthBindings();
  authBindings.dependencies();
  
  // Initialize Habit dependencies
  final habitBindings = HabitBindings();
  habitBindings.dependencies();
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
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: AppRoutes.habits, // Alterado para habits como rota inicial
      getPages: AppRoutes.routes,
      initialBinding: AuthBindings(),
    );
  }
}

