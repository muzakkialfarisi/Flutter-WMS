import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/tenant_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class TenantProvider with ChangeNotifier {
  List<TenantModel> _tenants = [];
  List<TenantModel> get tenants => _tenants;

  set tenants(List<TenantModel> tenants) {
    _tenants = tenants;
    notifyListeners();
  }

  Future<List<TenantModel>> gettenants({
    required String apikey,
    required String token,
    required String houseCode,
  }) async {
    try {
      var url = "$urlApi/Tenants?HouseCode=$houseCode";
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
        var data = jsonDecode(response.body);
        List<TenantModel> tenants = [];
        tenants.add(TenantModel.kosong());
        for (var item in data) {
          tenants.add(TenantModel.fromJson(item));
        }
        _tenants = tenants;
        return tenants;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
