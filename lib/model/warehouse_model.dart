class WarehouseModel {
  String? houseCode;
  String? houseName;

  WarehouseModel({
    this.houseCode,
    this.houseName,
  });

  WarehouseModel.fromJson(Map<String, dynamic> json) {
    houseCode = json['houseCode'];
    houseName = json['houseName'];
  }

  WarehouseModel.kosong() {
    houseCode = '';
    houseName = 'ALL';
  }

  Map<String, dynamic> toJson() {
    return {
      'houseCode': houseCode,
      'houseName': houseName,
    };
  }
}

class UninitializedWarehouseModel extends WarehouseModel {}
