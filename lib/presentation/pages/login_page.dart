import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import './register_page.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController controller;

  LoginPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
                const SizedBox(height: 16),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    controller.login(emailController.text, passwordController.text);
                    },
                  child: const Text('Entrar'),
                )),
                TextButton(
                  onPressed: () {
                    Get.to(() => RegisterPage(controller: controller));
                    },
                  child: const Text('Registrar'),
                ),
                Obx(() => Text(controller.error.value, style: const TextStyle(color: Colors.red)
                )),
              ],
            ),
          ),
        )
      ),
    );
  }
}
