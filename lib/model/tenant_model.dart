class TenantModel {
  String? tenantid;
  String? name;

  TenantModel({
    this.tenantid,
    this.name,
  });

  TenantModel.fromJson(Map<String, dynamic> json) {
    tenantid = json['tenantId'];
    name = json['name'];
  }

  TenantModel.kosong() {
    tenantid = '';
    name = 'ALL';
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantid': tenantid,
      'name': name,
    };
  }
}

class UninitializedtenantModel extends TenantModel {}
