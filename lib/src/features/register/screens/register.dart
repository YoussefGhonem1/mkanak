import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/src/features/login/screens/login.dart';
import 'package:rento/src/features/register/provider/register_provider.dart';
import 'package:rento/src/shared/componants/custom_text_form_field.dart';
import 'package:rento/src/shared/componants/valid.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerProvider);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body:
          registerController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: registerController.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "إنشاء حسابك",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "انضم إلينا لتجربة صيفية لا نهاية لها",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: registerController.nameController,
                                  label: "الاسم ثنائي",
                                  prefixIcon: Icons.person,
                                  validator: (val) => validInput(val!, 3, 30),
                                ),
                                const SizedBox(height: 20),

                                CustomTextFormField(
                                  controller:
                                      registerController.phoneController,
                                  label: "رقم الهاتف",
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "رقم الهاتف مطلوب";
                                    }
                                    if (val.length != 11 ||
                                        !RegExp(r'^[0-9]+$').hasMatch(val)) {
                                      return " رقم هاتف غير صحيح";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomTextFormField(
                                  controller:
                                      registerController.passwordController,
                                  label: "كلمة المرور",
                                  prefixIcon: Icons.lock,
                                  isPassword: true,
                                  validator: (val) => validInput(val!, 6, 30),
                                ),
                                const SizedBox(height: 20),
                                CustomTextFormField(
                                  controller:
                                      registerController
                                          .confirmPasswordController,
                                  label: "تأكيد كلمة المرور",
                                  prefixIcon: Icons.lock_reset,
                                  isPassword: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "تأكيد كلمة المرور مطلوب";
                                    }
                                    if (val !=
                                        registerController
                                            .passwordController
                                            .text) {
                                      return "كلمة المرور غير متطابقة";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'owner',
                                      groupValue:
                                          registerController.selectedRole,
                                      onChanged: (value) {
                                        registerController.setRole(value!);
                                      },
                                      activeColor: Colors.teal[900],
                                    ),
                                    Text(
                                      'مالك',
                                      style: TextStyle(color: Colors.teal[900]),
                                    ),
                                    const SizedBox(width: 20),
                                    Radio<String>(
                                      value: 'renter',
                                      groupValue:
                                          registerController.selectedRole,
                                      onChanged: (value) {
                                        registerController.setRole(value!);
                                      },
                                      activeColor: Colors.teal[900],
                                    ),
                                    Text(
                                      'مستأجر',
                                      style: TextStyle(color: Colors.teal[900]),
                                    ),
                                  ],
                                ),
                                if (registerController.errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      registerController.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const SizedBox(height: 20),
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
                                        // Remove horizontal padding for full width
                                      ),
                                    ),
                                    onPressed:
                                        () => registerController.register(
                                          context,
                                        ),

                                    child: const Text(
                                      "سجل",
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
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        " هل لديك حساب بالفعل؟",
                                        style: TextStyle(
                                          color: Colors.teal[900],
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        " تسجيل الدخول ",
                                        style: TextStyle(
                                          color: Colors.orange[900],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
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
    );
  }
}
