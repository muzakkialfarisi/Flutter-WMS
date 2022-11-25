class ProductPickDoneModel {
  String? orderId;
  String? ordProductId;
  String? productId;
  String? productName;
  String? sku;
  String? productLevel;
  String? quantity;
  String? imageProduk;
  String? iku;
  String? storageCode;
  String? binCode;
  String? binName;
  String? levelCode;
  String? levelName;
  String? sectionCode;
  String? sectionName;
  String? columnCode;
  String? columnName;
  String? rowCode;
  String? rowName;
  String? zoneCode;
  String? zoneName;
  String? sizeCode;
  String? idPick;
  String? pickedStatus;

  ProductPickDoneModel({
    this.orderId,
    this.productId,
    this.productName,
    this.sku,
    this.productLevel,
    this.quantity,
    this.imageProduk,
    this.iku,
    this.storageCode,
    this.binCode,
    this.binName,
    this.levelCode,
    this.levelName,
    this.rowCode,
    this.rowName,
    this.sectionCode,
    this.sectionName,
    this.columnCode,
    this.columnName,
    this.zoneCode,
    this.zoneName,
    this.sizeCode,
    this.idPick,
    this.pickedStatus,
  });

  ProductPickDoneModel.fromJson(
    Map<String, dynamic> json,
  ) {
    ordProductId = json['ordProductId'].toString();
    orderId = "";
    productId = json['productId'].toString();
    productName = json['masProductData']['productName'];
    sku = json['masProductData']['sku'];
    productLevel = json['masProductData']['productLevel'];
    imageProduk = json['masProductData']['beautyPicture'];
    iku = json['iku'].toString();
    quantity = json['quantity'].toString();
    sectionName = "";
    idPick = "";
    pickedStatus = "";
  }

  Map<String, dynamic> toJson() {
    return {
      'ordProductId': ordProductId,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'productLevel': productLevel,
      'quantity': quantity,
      'imageProduk': imageProduk,
      'iku': iku,
      'storageCode': storageCode,
      'sizeCode': sizeCode,
      'binCode': binCode,
      'binName': binName,
      'levelCode': levelCode,
      'levelName': levelName,
      'sectionCode': sectionCode,
      'sectionName': sectionName,
      'columnCode': columnCode,
      'columnName': columnName,
      'rowCode': rowCode,
      'rowName': rowName,
      'zoneCode': zoneCode,
      'zoneName': zoneName,
      'idPick': idPick,
      'pickedStatus': pickedStatus,
    };
  }
}

class UninitializedProductPickDoneModel extends ProductPickDoneModel {}
