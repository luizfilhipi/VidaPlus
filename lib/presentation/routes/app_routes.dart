import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/habit_tracking_page.dart';
import '../pages/add_habit_page.dart';
import '../controllers/auth_controller.dart';
import '../bindings/habit_bindings.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (authController.user.value == null && route != AppRoutes.login && route != AppRoutes.register) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String habits = '/habits';
  static const String addHabit = '/add-habit';

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginPage(controller: Get.find<AuthController>()),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(controller: Get.find<AuthController>()),
    ),
    GetPage(
      name: habits,
      page: () => const HabitTrackingPage(),
      binding: HabitBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: addHabit,
      page: () => const AddHabitPage(),
      binding: HabitBindings(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
