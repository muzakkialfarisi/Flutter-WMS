class ProductPutAwayModel {
  String? productId;
  String? productCode;
  String? doProductId;
  String? productName;
  String? sku;
  String? productLevel;
  String? quantity;
  String? imageProduk;
  String? status;
  String? qtyarrival;
  String? notearrival;
  String? doProductCode;
  String? storageCode;
  String? datePutAway;
  String? sisaQty;
  String? sizeCode;
  String? sizeName;
  String? zoneCode;

  ProductPutAwayModel({
    this.productId,
    this.productCode,
    this.doProductId,
    this.productName,
    this.sku,
    this.productLevel,
    this.quantity,
    this.imageProduk,
    this.status,
    this.qtyarrival,
    this.notearrival,
    this.doProductCode,
    this.storageCode,
    this.datePutAway,
    this.sisaQty,
    this.sizeCode,
    this.sizeName,
    this.zoneCode,
  });

  ProductPutAwayModel.fromJson(
    Map<String, dynamic> json,
    String sisaqty,
  ) {
    productId = json['productId'].toString();
    doProductId = json['doProductId'].toString();
    doProductCode = json['doProductCode'];
    productName = json['masProductData']['productName'];
    productCode = json['masProductData']['productCode'];
    sku = json['masProductData']['sku'];
    productLevel = json['masProductData']['productLevel'];
    imageProduk = json['masProductData']['beautyPicture'];
    imageProduk = json['masProductData']['beautyPicture'];
    zoneCode = json['masProductData']['zoneCode'];
    sizeCode = json['masProductData']['sizeCode'];
    sizeName = json['masProductData']['invStorageSize']['sizeName'];
    quantity = json['quantity'].toString();
    sisaQty = sisaqty;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productCode': productCode,
      'doProductCode': doProductCode,
      'doProductId': doProductId,
      'productName': productName,
      'sku': sku,
      'productLevel': productLevel,
      'quantity': quantity,
      'imageProduk': imageProduk,
      'status': status,
      'qtyarrival': qtyarrival,
      'notearrival': notearrival,
      'storageCode': storageCode,
      'datePutAway': datePutAway,
      'sisaQty': sisaQty,
      'sizeCode': sizeCode,
      'sizeName': sizeName,
      'zoneCode': zoneCode,
    };
  }
}

class UninitializedProductPutAwayModel extends ProductPutAwayModel {}
