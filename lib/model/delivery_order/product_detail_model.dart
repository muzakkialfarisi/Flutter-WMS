class ProductDetailModel {
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
  String? iku;
  String? zona;
  String? size;
  String? kategori;
  String? doProductCode;
  String? statusDo;

  ProductDetailModel({
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
    this.iku,
    this.zona,
    this.size,
    this.kategori,
    this.doProductCode,
    this.statusDo,
  });

  ProductDetailModel.fromJson(
    Map<String, dynamic> json,
    List json2,
    String diku,
    String dzona,
    String dsize,
    String dkategori,
  ) {
    productId = json['productId'].toString();
    doProductId = json['doProductId'].toString();
    doProductCode = json['doProductCode'];
    productName = json['masProductData']['productName'];
    productCode = json['masProductData']['productCode'];
    sku = json['masProductData']['sku'];
    productLevel = json['masProductData']['productLevel'];
    imageProduk = json['masProductData']['beautyPicture'];
    quantity = json['quantity'].toString();
    if (json2[0].toString().isEmpty) {
      qtyarrival = "0";
      statusDo = "DO";
    } else {
      qtyarrival = json2[0].toString();
      if (int.parse(json2[0].toString()) ==
          int.parse(json['quantity'].toString())) {
        statusDo = "AR";
      } else {
        statusDo = "DO";
      }
    }
    notearrival = json2[1].toString();
    status = json2[2].toString();
    iku = diku;
    zona = dzona;
    size = dsize;
    kategori = dkategori;
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
      'statusDO': statusDo,
      'qtyarrival': qtyarrival,
      'notearrival': notearrival,
      'iku': iku,
      'zona': zona,
      'size': size,
      'kategori': kategori,
    };
  }
}

class UninitializedProductDetailModel extends ProductDetailModel {}
