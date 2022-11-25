class DataStorageModel {
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

  DataStorageModel({
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
  });

  DataStorageModel.fromJson(Map<String, dynamic> json) {
    storageCode = json['storageCode'].toString();
    sizeCode = json['sizeCode'].toString();
    binCode = json['binCode'].toString();
    binName = json['invStorageBin']['binName'].toString();
    levelCode =
        json['invStorageBin']['invStorageLevel']['levelCode'].toString();
    levelName =
        json['invStorageBin']['invStorageLevel']['levelName'].toString();
    sectionCode = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['sectionsCode']
        .toString();
    sectionName = "";
    columnCode = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['columnCode']
        .toString();
    columnName = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['columnName']
        .toString();
    rowCode = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['rowCode']
        .toString();
    rowName = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['rowName']
        .toString();
    zoneCode = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['invStorageZone']['zoneCode']
        .toString();
    zoneName = json['invStorageBin']['invStorageLevel']['invStorageColumn']
            ['invStorageRow']['invStorageZone']['zoneName']
        .toString();
  }

  DataStorageModel.kosong() {
    storageCode = '';
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}

class UninitializedDataStorageModel extends DataStorageModel {}
