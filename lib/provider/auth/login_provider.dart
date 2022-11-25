import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  Future<List> login({
    required String apikey,
    required String? username,
    required String? password,
  }) async {
    try {
      var url = "$urlApi/Auth/login";
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = jsonEncode({
        'username': username,
        'password': password,
        // 'apikey': apikey,
      });
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final SharedPreferences share = await SharedPreferences.getInstance();
        share.setString("token", token);
        share.setString("userId", decodedToken["UserId"]);
        share.setString("userName", decodedToken["UserName"]);
        share.setString("namaDepan", decodedToken["FirstName"]);
        share.setString("namaBelakang", decodedToken["LastName"]);
        share.setString("houseCode", decodedToken["HouseCode"]);
        share.setString("houseName", decodedToken["HouseName"]);

        return [200, ''];
      } else {
        return [400, response.body];
      }
    } catch (e) {
      print('error');
      print(e);
      return [];
    }
  }
}
