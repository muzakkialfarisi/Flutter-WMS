import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/put_away/put_away_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class PutAwayProvider with ChangeNotifier {
  List<PutAwayModel> _putAways = [];
  List<PutAwayModel> get putAways => _putAways;

  set putAways(List<PutAwayModel> putAways) {
    _putAways = putAways;
    notifyListeners();
  }

  Future<List<PutAwayModel>> getDeliveryOrders({
    required String apikey,
    required String token,
    String? noDo,
    String? date,
    String? tenant,
    required String? houseCode,
    required String? status,
  }) async {
    try {
      var url =
          "$urlApi/DeliveryOrders?NoDo=$noDo&DateDelivered=$date&TenantId=$tenant&HouseCode=$houseCode&Status=$status";
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
        var data = jsonDecode(response.body);
        List<PutAwayModel> putAways = [];
        for (var item in data) {
          putAways.add(PutAwayModel.fromJson(item));
        }
        _putAways = putAways;
        return _putAways;
      } else {
        return [];
      }
    } catch (e) {
      print('error');
      print(e);
      return [];
    }
  }
}
