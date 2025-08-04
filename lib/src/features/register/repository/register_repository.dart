import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/src/features/register/models/register_model.dart';

class RegisterRepository {
  final Crud crud;

  RegisterRepository(this.crud);
  
  Future<Map> register(RegisterModel model) async {
    final data = model.toJson().map((key, value) => MapEntry(key, value.toString()));
    print("Sending data: $data");

    final response = await crud.postRequest(linkRegister, data);
    print("Register response: $response");
    return response;
  }
}
