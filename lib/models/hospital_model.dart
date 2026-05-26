class HospitalModel {
  final String id;
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int totalBeds;
  final bool isOpen;
  final String phone;

  HospitalModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceKm = 0.0,
    this.totalBeds = 0,
    this.isOpen = true,
    this.phone = '',
  });

  String get formattedDistance =>
      distanceKm < 1 ? '${(distanceKm * 1000).round()} m' : '${distanceKm.toStringAsFixed(1)} KM';

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'distance_km': distanceKm,
        'total_beds': totalBeds,
        'is_open': isOpen ? 1 : 0,
        'phone': phone,
      };

  factory HospitalModel.fromMap(Map<String, dynamic> map) => HospitalModel(
        id: map['id'] as String,
        name: map['name'] as String,
        type: map['type'] as String,
        address: map['address'] as String,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        distanceKm: (map['distance_km'] as num?)?.toDouble() ?? 0.0,
        totalBeds: (map['total_beds'] as int?) ?? 0,
        isOpen: (map['is_open'] as int?) == 1,
        phone: (map['phone'] as String?) ?? '',
      );
}