import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class CekProductArrivalProvider with ChangeNotifier {
  Future<List> getdel({
    required String token,
    required String apikey,
    required String dOProductId,
  }) async {
    try {
      var url = "$urlApi/Arrivals/$dOProductId";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == null) {
          return ['', '', '0'];
        } else {
          var dt = jsonDecode(response.body);
          List<String> data = [
            dt['quantity'].toString(),
            dt['note'] + "|",
            "1"
          ];

          return data;
        }
      } else {
        return ['', '', '0'];
      }
    } catch (e) {
      return ['', '', '0'];
    }
  }

  Future<List<String>> getiku({
    required String apikey,
    required String dOProductId,
    required String token,
  }) async {
    try {
      var url = "$urlApi/ItemProducts?doProductId=$dOProductId";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      // print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body).isEmpty) {
          return [];
        } else {
          var data = jsonDecode(response.body);
          List<String> iku = [];
          for (var item in data) {
            iku.add(item['iku']);
          }
          return iku;
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> getzona({
    required String token,
    required String apikey,
    required String zoneCode,
  }) async {
    try {
      var url = "$urlApi/Storages/Zones/$zoneCode";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      // print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var dt = jsonDecode(response.body);
        return dt['zoneName'].toString();
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> getSize({
    required String token,
    required String apikey,
    required String sizeCode,
  }) async {
    try {
      var url = "$urlApi/Storages/Sizes/$sizeCode";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      // print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var dt = jsonDecode(response.body);
        return dt['sizeName'].toString();
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> getkategori({
    required String token,
    required String apikey,
    required String categoryId,
  }) async {
    try {
      var url = "$urlApi/Storages/Categories/$categoryId";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      // print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var dt = jsonDecode(response.body);
        return dt['storageCategoryName'].toString();
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
