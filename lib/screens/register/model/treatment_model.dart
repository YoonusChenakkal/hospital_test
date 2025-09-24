class Branch {
  final int? id;
  final String? name;
  final int? patientsCount;
  final String? location;
  final String? phone;
  final String? mail;
  final String? address;
  final String? gst;
  final bool? isActive;

  Branch({
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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
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

  Map<String, dynamic> toJson() => {
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

class Treatment {
  final int? id;
  final List<Branch> branches;
  final String? name;
  final String? duration;
  final String? price;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  Treatment({
    this.id,
    List<Branch>? branches,
    this.name,
    this.duration,
    this.price,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  }) : branches = branches ?? [];

  factory Treatment.fromJson(Map<String, dynamic> json) {
    var branchesJson = json['branches'] as List<dynamic>?;
    List<Branch> branchList = branchesJson != null
        ? branchesJson.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList()
        : [];

    return Treatment(
      id: json['id'] as int?,
      branches: branchList,
      name: json['name'] as String?,
      duration: json['duration'] as String?,
      price: json['price'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branches': branches.map((e) => e.toJson()).toList(),
        'name': name,
        'duration': duration,
        'price': price,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
