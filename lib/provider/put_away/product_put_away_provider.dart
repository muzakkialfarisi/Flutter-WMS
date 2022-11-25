import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:wms_deal_ncs/model/put_away/product_put_away_model.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class ProductPutAwayProvider with ChangeNotifier {
  List<ProductPutAwayModel> _productPutAways = [];
  List<ProductPutAwayModel> get productPutAways => _productPutAways;

  set productPutAways(List<ProductPutAwayModel> productPutAways) {
    _productPutAways = productPutAways;
    notifyListeners();
  }

  Future<List<ProductPutAwayModel>> getProductPutAways({
    required String apikey,
    required String token,
    required String noDo,
    required String productlevel,
    required String namaProduk,
  }) async {
    try {
      String level = "";
      if (productlevel != 'All') {
        level = productlevel;
      }
      var url =
          "$urlApi/DeliveryOrders/$noDo/Products?NoDo=$noDo&ProductLevel=$level&ProductName=${namaProduk.toLowerCase()}";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (var item in data) {
          String sisa = item['quantity'].toString();
          if (item['masProductData']['productLevel'].toString() == 'IKU') {
            var all = item['incItemProducts'];
            int totalSisa = 0;
            for (var item2 in all) {
              if (item2['status'] < 4) {
                totalSisa++;
              }
            }
            sisa = totalSisa.toString();
          } else {
            int totalA = 0;
            var all = item['incDeliveryOrderArrivals']['invProductPutaways'];

            if (all != '') {
              for (var item2 in all) {
                totalA = totalA + int.parse(item2['quantity'].toString());
              }
            }

            sisa = (item['quantity'] - totalA).toString();
          }

          productPutAways.add(ProductPutAwayModel.fromJson(item, sisa));
        }
        // _productPutAways = productPutAways;
        return productPutAways;
        // return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveProductPutAways({
    required String apikey,
    required String noDo,
    required String strimage,
    required String dOProductId,
    required String quantity,
    required String quantityall,
    required String note,
    required String arrivedBy,
    required String notaImage,
    required String houseCode,
    required String productId,
    required String action,
  }) async {
    try {
      var url = "$urlApi/DeliveryOrder/Saveproduct";
      var body = {
        // 'token': '',
        'NoDo': noDo,
        'strimage': strimage,
        'DOProductId': dOProductId,
        'Quantity': quantity,
        'Quantityall': quantityall,
        'Note': note,
        'ArrivedBy': arrivedBy,
        'NotaImage': notaImage,
        'HouseCode': houseCode,
        'ProductId': productId,
        'action': action,
      };

      var response = await http.post(
        Uri.parse(url),
        // headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['statuscode'] == 200) {
          var data = jsonDecode(response.body);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
