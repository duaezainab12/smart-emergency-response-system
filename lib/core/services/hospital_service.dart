import '../../models/hospital_model.dart';
import 'location_service.dart';

class HospitalService {
  /// Returns mock hospital list sorted by distance.
  /// Replace with a real API / DB call in production.
  static List<HospitalModel> getNearbyHospitals({
    double userLat = 33.6844,
    double userLng = 73.0479,
  }) {
    final rawList = [
      HospitalModel(
        id: 'h_001',
        name: 'City Hospital',
        type: 'General Hospital',
        address: 'G-9/4, Islamabad',
        latitude: 33.6901,
        longitude: 73.0512,
        totalBeds: 240,
        isOpen: true,
        phone: '+92-51-9260001',
      ),
      HospitalModel(
        id: 'h_002',
        name: 'Emergency Care Center',
        type: 'Emergency & Trauma',
        address: 'F-8 Markaz, Islamabad',
        latitude: 33.7080,
        longitude: 73.0479,
        totalBeds: 120,
        isOpen: true,
        phone: '+92-51-2850001',
      ),
      HospitalModel(
        id: 'h_003',
        name: 'Life Care Hospital',
        type: 'Multi-Specialty',
        address: 'Saddar, Rawalpindi',
        latitude: 33.6007,
        longitude: 73.0679,
        totalBeds: 180,
        isOpen: true,
        phone: '+92-51-5569001',
      ),
      HospitalModel(
        id: 'h_004',
        name: 'Shifa International',
        type: 'Private Hospital',
        address: 'H-8/4, Islamabad',
        latitude: 33.6638,
        longitude: 73.0234,
        totalBeds: 350,
        isOpen: true,
        phone: '+92-51-4603000',
      ),
      HospitalModel(
        id: 'h_005',
        name: 'PIMS Hospital',
        type: 'Teaching Hospital',
        address: 'G-8/3, Islamabad',
        latitude: 33.6784,
        longitude: 73.0427,
        totalBeds: 600,
        isOpen: false,
        phone: '+92-51-9261170',
      ),
    ];

    // Attach real distances and sort nearest-first
    final withDistance = rawList.map((h) {
      final km = LocationService.distanceBetween(
        startLat: userLat,
        startLng: userLng,
        endLat: h.latitude,
        endLng: h.longitude,
      );
      return HospitalModel(
        id: h.id,
        name: h.name,
        type: h.type,
        address: h.address,
        latitude: h.latitude,
        longitude: h.longitude,
        distanceKm: km,
        totalBeds: h.totalBeds,
        isOpen: h.isOpen,
        phone: h.phone,
      );
    }).toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return withDistance;
  }
}