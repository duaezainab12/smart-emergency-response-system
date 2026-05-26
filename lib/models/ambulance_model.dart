enum AmbulanceStatus { available, dispatched, maintenance }

class AmbulanceModel {
  final String id;
  final String unitNumber;
  final String driverName;
  final String driverPhone;
  final double latitude;
  final double longitude;
  final AmbulanceStatus status;

  AmbulanceModel({
    required this.id,
    required this.unitNumber,
    required this.driverName,
    required this.driverPhone,
    required this.latitude,
    required this.longitude,
    this.status = AmbulanceStatus.available,
  });

  String get statusLabel {
    switch (status) {
      case AmbulanceStatus.available:   return 'Available';
      case AmbulanceStatus.dispatched:  return 'Dispatched';
      case AmbulanceStatus.maintenance: return 'Maintenance';
    }
  }

  AmbulanceModel copyWith({
    double? latitude,
    double? longitude,
    AmbulanceStatus? status,
  }) {
    return AmbulanceModel(
      id: id,
      unitNumber: unitNumber,
      driverName: driverName,
      driverPhone: driverPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'unit_number': unitNumber,
        'driver_name': driverName,
        'driver_phone': driverPhone,
        'latitude': latitude,
        'longitude': longitude,
        'status': status.name,
      };

  factory AmbulanceModel.fromMap(Map<String, dynamic> map) => AmbulanceModel(
        id: map['id'] as String,
        unitNumber: map['unit_number'] as String,
        driverName: map['driver_name'] as String,
        driverPhone: map['driver_phone'] as String,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        status: AmbulanceStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => AmbulanceStatus.available,
        ),
      );
}