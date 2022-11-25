import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/delivery_order/delivery_order_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class DeliveryOrderProvider with ChangeNotifier {
  List<DeliveryOrderModel> _deliveryOrders = [];
  List<DeliveryOrderModel> get deliveryOrders => _deliveryOrders;

  set deliveryOrders(List<DeliveryOrderModel> deliveryOrders) {
    _deliveryOrders = deliveryOrders;
    notifyListeners();
  }

  Future<List<DeliveryOrderModel>> getDeliveryOrders({
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
        'Authorization': 'Bearer $token'
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<DeliveryOrderModel> deliveryOrders = [];
        for (var item in data) {
          deliveryOrders.add(DeliveryOrderModel.fromJson(item));
        }
        _deliveryOrders = deliveryOrders;
        return _deliveryOrders;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> uploadDo({
    required String apikey,
    required String? noDo,
    required String? strImage,
    required String? token,
  }) async {
    try {
      var url = "$urlApi/Arrivals/UploadManifest";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'DONumber': noDo,
        'NotaImage': strImage,
      });
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
