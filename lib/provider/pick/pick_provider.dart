import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/pick/pick_model.dart';
import 'package:wms_deal_ncs/model/pick/product_pick_done_model.dart';
import 'package:wms_deal_ncs/model/pick/product_pick_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class PickProvider with ChangeNotifier {
  List<PickModel> _picks = [];
  List<PickModel> get picks => _picks;

  set picks(List<PickModel> picks) {
    _picks = picks;
    notifyListeners();
  }

  Future<List<PickModel>> getpicks({
    required String apikey,
    required String token,
    required String orderId,
    required String dateOrder,
    required String tenantId,
    required String houseCode,
    required String flagPick,
    required String status,
  }) async {
    try {
      var url =
          "$urlApi/SalesOrders?OrderId=$orderId&DateOrdered=&TenantId=$tenantId&HouseCode=$houseCode&FlagPick=$flagPick&Status=$status";
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
        List<PickModel> picks = [];
        for (var item in data) {
          picks.add(PickModel.fromJson(item, item));
        }
        _picks = picks;
        return picks;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> getAssignPick({
    required String apikey,
    required String token,
    required String idPick,
    required String userId,
  }) async {
    try {
      var url =
          "$urlApi/salesorderassigns/GetPickAssignIdByUserBySOStorage?userId=$userId&Id=$idPick";
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

        return data['pickAssignId'];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<List> saveOrderPicks({
    required String apikey,
    required String token,
    required List orderId,
    required String houseCode,
    required String userId,
  }) async {
    try {
      var url = "$urlApi/SalesOrderAssigns?HouseCode=$houseCode";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode(orderId);

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        // headers: headers,
      );

      if (response.statusCode == 200) {
        return ['200', ''];
      } else {
        return [response.statusCode, response.body];
      }
    } catch (e) {
      return ['400', 'Tidak Dapat Menggapai Server'];
    }
  }

  Future<List<ProductPickModel>> getPickproduct({
    required String apikey,
    required String token,
    required String pickedStatus,
    required String userId,
  }) async {
    try {
      var url = "$urlApi/Picks/$userId?PickedStatus=$pickedStatus";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      // print(url);
      // // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<ProductPickModel> prod = [];
        for (var item in data) {
          var kodeStorage = item['storageCode'];
          var url2 = "$urlApi/Storages/StorageCodes/$kodeStorage";
          var headers2 = {
            'Content-Type': 'application/json',
            // HttpHeaders.authorizationHeader: token,
            'Authorization': 'Bearer $token'
          };
          // print(url);
          var response2 = await http.get(
            Uri.parse(url2),
            headers: headers2,
          );
          var data2 = jsonDecode(response2.body);
          prod.add(ProductPickModel.fromJson(item, data2));
        }
        return prod;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> saveProductlist({
    required String apikey,
    required String token,
    required String iku,
    required String storageCode,
    required String total,
    required String userId,
    required String qcStatus,
    required String qcremark,
    required String idPick,
  }) async {
    try {
      var url = "$urlApi/Picks?Id=$idPick";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var qcsts = "";
      var qcrmk = "";
      if (qcStatus == "Accept") {
        qcsts = "Accept";
      } else if (qcStatus == "Reject") {
        qcsts = "Reject";
        qcrmk = qcremark;
      }
      var body = jsonEncode({
        'storageCode': storageCode,
        // 'QtyPick': total,
        'QualityCheckedStatus': qcsts,
        'QualityCheckedRemark': qcrmk,
      });
      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return [200, ''];
      } else {
        return [response.statusCode, response.body];
      }
    } catch (e) {
      return [200, 'Periksa Koneksi Internet Anda'];
    }
  }

  Future<List<ProductPickDoneModel>> getproductDone({
    required String apikey,
    required String orderId,
    required String token,
    required String productLevel,
    required String nameproduct,
  }) async {
    try {
      String level = "";
      if (productLevel == "All") {
        level = "";
      } else {
        level = productLevel;
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var url =
          "$urlApi/SalesOrders/$orderId/Products?ProductLevel=$level&ProductName=${nameproduct.toLowerCase()}";
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<ProductPickDoneModel> picks = [];
        for (var item in data) {
          List data2 = [];
          picks.add(ProductPickDoneModel.fromJson(item));
        }
        return picks;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> uploadStagging({
    required String apikey,
    required String token,
    required String id,
    required String strImage,
    required String userId,
  }) async {
    try {
      var url = "$urlApi/Picks/UploadStage";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'userId': userId,
        'pickAssignId': id,
        'imageStaged': strImage,
      });
      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return [200, ''];
      } else {
        return [response.statusCode, response.body];
      }
    } catch (e) {
      return ['400', 'Tidak Dapat Menggapai Server'];
    }
  }
}
