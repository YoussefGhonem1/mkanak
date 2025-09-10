
import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/src/features/login/models/login_model.dart';

class LoginRepository {
  final Crud crud;

  LoginRepository(this.crud);

  Future<Map<String, dynamic>> login(LoginModel model) async {
    final data = model.toJson().map((key, value) => MapEntry(key, value.toString()));
    final response = await crud.postRequest(linkLogin, data);
    return response is Map<String, dynamic> ? response : {};
  }

  Future<void> updateFcmToken(String userId, String fcmToken) async {
    await crud.postRequest(linkUpdateUserFcmToken, {
      "user_id": userId,
      "fcm_token": fcmToken,
    });
  }
}