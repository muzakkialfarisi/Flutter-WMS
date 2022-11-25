class DeliveryOrderModel {
  String? noDo;
  String? doSupplier;
  String? dateCreated;
  String? dateDelivered;
  String? dateArrived;
  String? tenatId;
  String? tenatName;
  String? houseName;
  String? houseCode;
  String? houseAddress;
  String? status;

  DeliveryOrderModel({
    this.noDo,
    this.doSupplier,
    this.tenatId,
    this.houseName,
    this.houseCode,
    this.tenatName,
    this.dateCreated,
    this.dateDelivered,
    this.dateArrived,
    this.houseAddress,
    this.status,
  });

  DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    noDo = json['doNumber'];
    doSupplier = json['doSupplier'];
    dateCreated = json['dateCreated'];
    dateDelivered = json['dateDelivered'];
    dateArrived = json['dateArrived'];
    tenatId = json['tenantId'];
    tenatName = json['masDataTenant']['name'];
    houseCode = json['houseCode'];
    houseName = json['masHouseCode']['houseName'];
    houseAddress = json['masHouseCode']['address'];
    status = json['status'];
  }

  DeliveryOrderModel.kosong() {
    noDo = '';
    doSupplier = '';
    tenatId = '';
    houseName = '';
    houseCode = '';
    tenatName = '';
    dateCreated = '';
    dateDelivered = '';
    dateArrived = '';
    houseAddress = '';
    status = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'noDo': noDo,
      'doSupplier': doSupplier,
      'tenatId': tenatId,
      'tenatName': tenatName,
      'houseName': houseName,
      'houseCode': houseCode,
      'dateCreated': dateCreated,
      'dateDelivered': dateDelivered,
      'dateArrived': dateArrived,
      'houseAddress': houseAddress,
      'status': status,
    };
  }
}

class UninitializedDeliveryOrderModel extends DeliveryOrderModel {}
