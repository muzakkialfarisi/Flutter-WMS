class DataIkuModel {
  String? iku;
  String? storageCode;
  String? datePutedAway;

  DataIkuModel({
    this.iku,
    this.storageCode,
    this.datePutedAway,
  });

  DataIkuModel.fromJson(
    String jiku,
    String stgCode,
    String dtputaway,
  ) {
    iku = jiku;
    storageCode = stgCode;
    datePutedAway = dtputaway;
  }

  DataIkuModel.kosong() {
    iku = '';
    storageCode = '';
    datePutedAway = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'iku': iku,
      'storageCode': storageCode,
      'datePutedAway': datePutedAway,
    };
  }
}

class UninitializedDataIkuModel extends DataIkuModel {}
