class PickModel {
  String? orderId;
  String? dateOrder;
  String? houseCode;
  String? nama;
  String? noTelp;
  String? address;
  String? tenantName;
  String? totalProduct;
  String? totalQty;
  bool? checked;

  PickModel(
      {this.orderId,
      this.dateOrder,
      this.houseCode,
      this.nama,
      this.noTelp,
      this.address,
      this.tenantName,
      this.totalProduct,
      this.totalQty,
      this.checked});

  PickModel.fromJson(Map<String, dynamic> json, Map<String, dynamic> json2) {
    orderId = json['orderId'];
    houseCode = json['houseCode'];
    dateOrder = json['dateOrdered'];
    nama = json['outSalesOrderConsignee']['cneeName'];
    noTelp = json['outSalesOrderConsignee']['cneePhone'];
    address = json['outSalesOrderConsignee']['cneeAddress'];
    tenantName = json['masDataTenant']['name'];
    // totalProduct = json2['totalproduct'].toString();
    // totalQty = json2['totalquantity'].toString();
    checked = false;
    totalProduct = "2";
    totalQty = "2";
  }

  PickModel.kosong() {
    orderId = '';
    dateOrder = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'dateOrder': dateOrder,
      'houseCode': houseCode,
      'nama': nama,
      'noTelp': noTelp,
      'address': address,
      'tenantName': tenantName,
      'totalProduct': totalProduct,
      'totalQty': totalQty,
      'checked': checked,
    };
  }
}

class UninitializedPickModel extends PickModel {}
