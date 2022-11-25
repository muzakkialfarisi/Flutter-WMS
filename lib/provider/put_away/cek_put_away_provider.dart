import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wms_deal_ncs/model/put_away/data_iku_model.dart';
import 'package:wms_deal_ncs/model/put_away/data_storage_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class CekPutAwayProvider with ChangeNotifier {
  Future<List<DataIkuModel>> getiku({
    required String apikey,
    required String token,
    required String dOProductId,
    required String noQrCode,
  }) async {
    try {
      var url = "$urlApi/ItemProducts/$noQrCode";
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
        List<DataIkuModel> iku = [];
        iku.add(
          DataIkuModel.fromJson(data['iku'], data['storageCode'].toString().toLowerCase(),
              data['status'].toString()),
        );

        return iku;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<DataStorageModel>> geStorage({
    required String apikey,
    required String token,
    required String kodeStorage,
    required String houseCode,
  }) async {
    try {
      var url = "$urlApi/Storages/StorageCodes/$kodeStorage";
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
        List<DataStorageModel> storage = [];
        storage.add(DataStorageModel.fromJson(data));
        return storage;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> saveIku({
    required String apikey,
    required String noIku,
    required String doProductId,
    required String storageCode,
    required String token,
  }) async {
    try {
      var url = "$urlApi/PutAways/IKU?DOProductId=$doProductId";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'StorageCode': storageCode,
        'iku': noIku,
      });
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return ['200', ''];
      } else {
        return [response.statusCode.toString(), response.body];
      }
    } catch (e) {
      return ['500', 'Tidak Dapat Menggapai Server'];
    }
  }

  Future<List> saveSku({
    required String apikey,
    required String doProductId,
    required String storageCode,
    required String quantity,
    required String token,
  }) async {
    try {
      var url = "$urlApi/PutAways/SKU?DOProductId=$doProductId";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'StorageCode': storageCode,
        'Quantity': quantity,
        'iku': "",
      });
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return ['200', ''];
      } else {
        return [response.statusCode.toString(), response.body];
      }
    } catch (e) {
      return ['500', 'Tidak Dapat Menggapai Server'];
    }
  }
}
