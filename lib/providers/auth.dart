import "package:http/http.dart" as http;
import "package:aplikasi_whatsapp/config/api.dart";
import "dart:convert";

import "package:aplikasi_whatsapp/models/user.dart";

class AuthServices {
  bool isLoggedIn = false;

  static Future<bool> login(String hp, String password) async {
    var response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "hp": hp,
        "password": password,
      }),
    );

    if (jsonDecode(response.body)["status"] == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> regist(User user) async {
    var response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );

    if (jsonDecode(response.body)["status"] == 200) {
      return true;
    } else {
      return false;
    }
  }
}
