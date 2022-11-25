import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:wms_deal_ncs/model/delivery_order/product_detail_model.dart';
import 'package:wms_deal_ncs/provider/delivery_order/cek_product_arrival_provider.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:http/http.dart' as http;

class ProductDetailProvider with ChangeNotifier {
  List<ProductDetailModel> _productDetails = [];
  List<ProductDetailModel> get productDetails => _productDetails;

  set productDetails(List<ProductDetailModel> productDetails) {
    _productDetails = productDetails;
    notifyListeners();
  }

  Future<List<ProductDetailModel>> getProductDetails({
    required String apikey,
    required String token,
    required String noDo,
  }) async {
    try {
      var url = "$urlApi/DeliveryOrders/$noDo/Products";
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

        List<ProductDetailModel> productDetails = [];

        for (var item in data) {
          String zona = await CekProductArrivalProvider().getzona(
            apikey: '',
            token: token,
            zoneCode: item['masProductData']['zoneCode'].toString(),
          );
          // print(zona);
          String size = await CekProductArrivalProvider().getSize(
            apikey: '',
            token: token,
            sizeCode: item['masProductData']['sizeCode'].toString(),
          );
          String categoryname = await CekProductArrivalProvider().getkategori(
            apikey: '',
            token: token,
            categoryId: item['masProductData']['categoryId'].toString(),
          );
          List productD = await CekProductArrivalProvider().getdel(
            apikey: '',
            token: token,
            dOProductId: item['doProductId'].toString(),
          );
          productDetails.add(ProductDetailModel.fromJson(
            item,
            productD,
            "",
            zona,
            size,
            categoryname,
          ));
        }
        _productDetails = productDetails;
        return productDetails;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveProductDetails({
    required String token,
    required String strimage,
    required String dOProductId,
    required String quantity,
    required String note,
    required String arrivedBy,
  }) async {
    try {
      var url = "$urlApi/Arrivals?DOProductId=$dOProductId";
      var headers = {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: token,
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'DOProductId': dOProductId,
        'Quantity': quantity,
        'Note': note,
        'productImage': strimage,
        'ArrivedBy': arrivedBy,
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
