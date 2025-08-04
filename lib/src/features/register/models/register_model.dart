class RegisterModel {
  final String name;
  final String password;
  final String phone;
  final String type;

  RegisterModel({
    required this.name,
    required this.password,
    required this.phone,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": name,
      "password": password,
      "phone_number": phone,
      "type": type,
    };
  }
}
