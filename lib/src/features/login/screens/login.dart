// src/features/login/screens/login.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/src/features/login/provider/login_provider.dart';
import 'package:rento/src/features/register/screens/register.dart';
import 'package:rento/src/shared/componants/custom_text_form_field.dart';
import 'package:rento/src/shared/componants/valid.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    return Scaffold(
      body:
          loginController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: loginController.formKey,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "مرحبًا بعودتك",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.teal900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "قم بتسجيل الدخول لمواصلة رحلتك الصيفية",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.teal900,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomTextFormField(
                              controller: loginController.phoneController,
                              label: "رقم الهاتف",
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "رقم الهاتف مطلوب ";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: loginController.passwordController,
                              label: "كلمة المرور",
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              validator: (val) => validInput(val!, 6, 30),
                            ),
                            const SizedBox(height: 30),
                            if (loginController.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  loginController.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),
                                onPressed: () => loginNotifier.login(context),
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ليس لديك حساب؟",
                                    style: TextStyle(
                                      color: AppColors.teal900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    " سجل الان ",
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
