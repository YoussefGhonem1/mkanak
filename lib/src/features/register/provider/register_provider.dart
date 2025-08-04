import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/crud.dart';
import 'package:rento/src/features/register/models/register_model.dart';
import 'package:rento/src/features/register/repository/register_repository.dart';

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository(Crud());
});

final registerProvider = ChangeNotifierProvider((ref) {
  return RegisterController(ref.read(registerRepositoryProvider));
});

class RegisterController extends ChangeNotifier {
  final RegisterRepository repository;
   String? errorMessage;
    String? phoneError; 


 
  RegisterController(this.repository);

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String selectedRole = "user";
   
  void setError(String message) {
    errorMessage = message;
    notifyListeners();
  }
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
    setError("كلمة المرور وتأكيدها غير متطابقين");
    return;
  }

    isLoading = true;
    notifyListeners();

    final model = RegisterModel(
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
      type: selectedRole,
    );

    final result = await repository.register(model);
    print(result);
      if (result['status'] == "fail") {
    setError(result['message'] ?? "حدث خطأ غير معروف");
  } else {
    errorMessage = null;
    Navigator.of(context).pushReplacementNamed("/login");
  }
    isLoading = false;
    notifyListeners();

  }

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
  }
}
