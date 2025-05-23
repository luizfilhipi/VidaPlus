import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController controller;

  RegisterPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar')),
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
                    onPressed: () async{
                      await controller.register(emailController.text, passwordController.text);
                      if (controller.error.value.isEmpty) {
                        Get.back();
                      }
                    },
                    child: const Text('Cadastrar novo usuário'),
                  )),
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
