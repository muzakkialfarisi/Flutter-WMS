class ProductPickModel {
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

  ProductPickModel({
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

  ProductPickModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> json2,
  ) {
    ordProductId = json['ordProductId'].toString();
    orderId = json['outSalesOrderProduct']['orderId'].toString();
    productId = json['outSalesOrderProduct']['productId'].toString();
    productName = json['outSalesOrderProduct']['masProductData']['productName'];
    sku = json['outSalesOrderProduct']['masProductData']['sku'];
    productLevel =
        json['outSalesOrderProduct']['masProductData']['productLevel'];
    imageProduk =
        json['outSalesOrderProduct']['masProductData']['beautyPicture'];
    iku = json['iku'].toString();
    quantity = json['qtyPick'].toString();
    storageCode = json2['storageCode'].toString();
    sizeCode = json2['sizeCode'].toString();
    binCode = json2['binCode'].toString();
    binName = json2['invStorageBin']['binName'].toString();
    levelCode =
        json2['invStorageBin']['invStorageLevel']['levelCode'].toString();
    levelName =
        json2['invStorageBin']['invStorageLevel']['levelName'].toString();
    sectionCode = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['sectionsCode']
        .toString();
    sectionName = "";
    columnCode = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['columnCode']
        .toString();
    columnName = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['columnName']
        .toString();
    rowCode = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['rowCode']
        .toString();
    rowName = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['rowName']
        .toString();
    zoneCode = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['invStorageZone']['zoneCode']
        .toString();
    zoneName = json2['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['invStorageZone']['zoneName']
        .toString();
    idPick = json['id'].toString();
    pickedStatus = json['pickedStatus'].toString();
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

class UninitializedProductPickModel extends ProductPickModel {}
