enum EmergencyStatus { pending, dispatched, enRoute, arrived, completed, cancelled }

class EmergencyModel {
  final String id;
  final String patientName;
  final String emergencyType;
  final String severity;
  final double latitude;
  final double longitude;
  final String address;
  final EmergencyStatus status;
  final String? assignedDriverId;
  final DateTime createdAt;

  EmergencyModel({
    required this.id,
    required this.patientName,
    required this.emergencyType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.status = EmergencyStatus.pending,
    this.assignedDriverId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Human-readable status label
  String get statusLabel {
    switch (status) {
      case EmergencyStatus.pending:    return 'Pending';
      case EmergencyStatus.dispatched: return 'Dispatched';
      case EmergencyStatus.enRoute:    return 'En Route';
      case EmergencyStatus.arrived:    return 'Arrived';
      case EmergencyStatus.completed:  return 'Completed';
      case EmergencyStatus.cancelled:  return 'Cancelled';
    }
  }

  /// Copy with updated fields
  EmergencyModel copyWith({
    String? patientName,
    String? emergencyType,
    String? severity,
    double? latitude,
    double? longitude,
    String? address,
    EmergencyStatus? status,
    String? assignedDriverId,
  }) {
    return EmergencyModel(
      id: id,
      patientName: patientName ?? this.patientName,
      emergencyType: emergencyType ?? this.emergencyType,
      severity: severity ?? this.severity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      createdAt: createdAt,
    );
  }

  /// Serialize to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_name': patientName,
      'emergency_type': emergencyType,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status.name,
      'assigned_driver_id': assignedDriverId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Deserialize from Map (from SQLite)
  factory EmergencyModel.fromMap(Map<String, dynamic> map) {
    return EmergencyModel(
      id: map['id'] as String,
      patientName: map['patient_name'] as String,
      emergencyType: map['emergency_type'] as String,
      severity: map['severity'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: (map['address'] as String?) ?? '',
      status: EmergencyStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => EmergencyStatus.pending,
      ),
      assignedDriverId: map['assigned_driver_id'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  String toString() =>
      'EmergencyModel(id: $id, patient: $patientName, severity: $severity, status: $statusLabel)';
}