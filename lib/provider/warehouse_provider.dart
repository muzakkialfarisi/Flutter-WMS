import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/warehouse_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class WarehouseProvider with ChangeNotifier {
  List<WarehouseModel> _warehouses = [];
  List<WarehouseModel> get warehouses => _warehouses;

  set warehouses(List<WarehouseModel> warehouses) {
    _warehouses = warehouses;
    notifyListeners();
  }

  Future<List<WarehouseModel>> getwarehouses({
    required String apikey,
  }) async {
    try {
      var url = "$urlApi/DeliveryOrder/Getwarehouse";
      // var headers = {
      //   'Content-Type': 'application/json',
      // };
      var response = await http.get(
        Uri.parse(url),
        // headers: headers,
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['statuscode'] == 200) {
          var data = jsonDecode(response.body)['data'];
          List<WarehouseModel> warehouses = [];
          warehouses.add(WarehouseModel.kosong());
          for (var item in data) {
            warehouses.add(WarehouseModel.fromJson(item));
          }
          _warehouses = warehouses;
          return warehouses;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
