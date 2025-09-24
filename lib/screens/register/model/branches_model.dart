class BranchesModel {
  final int? id;
  final String? name;
  final int? patientsCount;
  final String? location;
  final String? phone;
  final String? mail;
  final String? address;
  final String? gst;
  final bool? isActive;

  BranchesModel({
    this.id,
    this.name,
    this.patientsCount,
    this.location,
    this.phone,
    this.mail,
    this.address,
    this.gst,
    this.isActive,
  });

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    return BranchesModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      patientsCount: json['patients_count'] as int?,
      location: json['location'] as String?,
      phone: json['phone'] as String?,
      mail: json['mail'] as String?,
      address: json['address'] as String?,
      gst: json['gst'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}

class BranchResponse {
  final List<BranchesModel> branches;

  BranchResponse({required this.branches});

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['branches'];
    return BranchResponse(
      branches: data is List
          ? data
                .map((e) => BranchesModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [], // return empty list if null or not a list
    );
  }

  Map<String, dynamic> toJson() {
    return {"branches": branches.map((e) => e.toJson()).toList()};
  }
}
