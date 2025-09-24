// Model for a single treatment detail
class PatientTreatmentDetail {
  final dynamic id;
  final String? male;
  final String? female;
  final int? patient;
  final int? treatment;
  final String? treatmentName;

  PatientTreatmentDetail({
    this.id,
    this.male,
    this.female,
    this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientTreatmentDetail.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentDetail(
      id: json['id'] ?? 0,
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      patient: json['patient'] ?? 0,
      treatment: json['treatment'] ?? 0,
      treatmentName: json['treatment_name'] ?? 'no treatment found',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'male': male,
    'female': female,
    'patient': patient,
    'treatment': treatment,
    'treatment_name': treatmentName,
  };
}

// // Model for a single branch
// class Branch {
//   final int? id;
//   final String? name;
//   final int? patientsCount;
//   final String? location;
//   final String? phone;
//   final String? mail;
//   final String? address;
//   final String? gst;
//   final bool? isActive;

//   Branch({
//     this.id,
//     this.name,
//     this.patientsCount,
//     this.location,
//     this.phone,
//     this.mail,
//     this.address,
//     this.gst,
//     this.isActive,
//   });

//   factory Branch.fromJson(Map<String, dynamic> json) {
//     return Branch(
//       id: json['id'] as int?,
//       name: json['name'] as String?,
//       patientsCount: json['patients_count'] as int?,
//       location: json['location'] as String?,
//       phone: json['phone'] as String?,
//       mail: json['mail'] as String?,
//       address: json['address'] as String?,
//       gst: json['gst'] as String?,
//       isActive: json['is_active'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'patients_count': patientsCount,
//     'location': location,
//     'phone': phone,
//     'mail': mail,
//     'address': address,
//     'gst': gst,
//     'is_active': isActive,
//   };
// }

// Model for a single patient
class Patient {
  final int? id;
  final List<PatientTreatmentDetail>? patientDetailsSet;
  // final Branch? branch;
  final String? user;
  final String? payment;
  final String? name;
  final String? phone;
  final String? address;
  final dynamic price;
  final int? totalAmount;
  final int? discountAmount;
  final int? advanceAmount;
  final int? balanceAmount;
  final String? dateNdTime;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  Patient({
    this.id,
    this.patientDetailsSet,
    // this.branch,
    this.user,
    this.payment,
    this.name,
    this.phone,
    this.address,
    this.price,
    this.totalAmount,
    this.discountAmount,
    this.advanceAmount,
    this.balanceAmount,
    this.dateNdTime,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    final details = (json['patientdetails_set'] as List?)
        ?.map((e) => PatientTreatmentDetail.fromJson(e))
        .toList();

    return Patient(
      id: json['id'],
      patientDetailsSet: details,
      // branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      user: json['user'] ?? 'no user',
      payment: json['payment'] ?? 'no payment',
      name: json['name'].toString().isEmpty
          ? 'no name found'
          : json['name'] ?? 'no name found',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      price: json['price'],
      totalAmount: json['total_amount'] ?? '',
      discountAmount: json['discount_amount'] ?? 0,
      advanceAmount: json['advance_amount'] ?? 0,
      balanceAmount: json['balance_amount'] ?? 0,
      dateNdTime: json['date_nd_time'] ?? 'no date found',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientdetails_set': patientDetailsSet?.map((e) => e.toJson()).toList(),
    // 'branch': branch?.toJson(),
    'user': user,
    'payment': payment,
    'name': name,
    'phone': phone,
    'address': address,
    'price': price,
    'total_amount': totalAmount,
    'discount_amount': discountAmount,
    'advance_amount': advanceAmount,
    'balance_amount': balanceAmount,
    'date_nd_time': dateNdTime,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// Main response model
class PatientResponse {
  final bool? status;
  final String? message;
  final List<Patient>? patient;

  PatientResponse({this.status, this.message, this.patient});

  factory PatientResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['patient'] as List?)
        ?.map((e) => Patient.fromJson(e))
        .toList();

    return PatientResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      patient: list,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'patient': patient?.map((e) => e.toJson()).toList(),
  };
}
