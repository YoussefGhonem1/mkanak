
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/crud.dart';
import 'package:rento/main.dart'; 
import 'package:rento/src/features/login/models/login_model.dart';
import 'package:rento/src/features/login/repository/login_repository.dart';
import 'package:rento/src/shared/routing/app_routes.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(Crud());
});

final loginProvider = ChangeNotifierProvider.autoDispose((ref) { 
  return LoginController(ref.read(loginRepositoryProvider));
});


class LoginController extends ChangeNotifier {
  final LoginRepository _repository;

  LoginController(this._repository);

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final model = LoginModel(
      phone: phoneController.text,
      password: passwordController.text,
    );

    try {
      final response = await _repository.login(model);

      if (response['status'] == "success") {
        await _saveUserData(response['data']);
        
        await _updateFcmToken();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "تم تسجيل الدخول بنجاح!")),
        );
                _navigateUser(context, response['data']['type'].toString());

      } else {
        errorMessage = response['message'] ?? "فشل تسجيل الدخول. تأكد من البيانات.";
      }
    } catch (e) {
      errorMessage = "حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.";
      print("Login Exception: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> data) async {
    await sharedPref.setString("id", data['id'].toString());
    await sharedPref.setString("username", data['username']);
    await sharedPref.setString("phone", data['phone_number']);
    await sharedPref.setString("type", data['type'].toString());
    await sharedPref.setString("balance", data['balance'].toString());
  }

  Future<void> _updateFcmToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      String? userId = sharedPref.getString("id");

      if (fcmToken != null && userId != null) {
        await _repository.updateFcmToken(userId, fcmToken);
        print("FCM Token sent to backend: $fcmToken");
      }
    } catch(e) {
      print("Failed to update FCM token: $e");
    }
  }

 void _navigateUser(BuildContext context, String userType) {

  Navigator.of(context).pushReplacementNamed(Routes.homeOwner);
}

 
}