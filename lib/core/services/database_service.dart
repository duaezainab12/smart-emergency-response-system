import '../database/local_db.dart';
import '../../models/emergency_model.dart';
import '../../models/user_model.dart';
import '../../models/hospital_model.dart';

/// Thin service layer over LocalDatabase.
/// Screens and providers call this — never LocalDatabase directly.
class DatabaseService {
  // ── Init ─────────────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    await LocalDatabase.database; // opens & creates schema if needed
  }

  // ── Emergency Requests ───────────────────────────────────────────────────
  static Future<void> saveEmergency(EmergencyModel model) =>
      LocalDatabase.insertEmergency(model);

  static Future<List<EmergencyModel>> fetchEmergencies() =>
      LocalDatabase.getAllEmergencies();

  static Future<void> updateEmergencyStatus(
          String id, EmergencyStatus status) =>
      LocalDatabase.updateEmergencyStatus(id, status);

  static Future<void> removeEmergency(String id) =>
      LocalDatabase.deleteEmergency(id);

  // ── Users ────────────────────────────────────────────────────────────────
  static Future<void> saveUser(UserModel user) =>
      LocalDatabase.insertUser(user);

  static Future<UserModel?> fetchUserByEmail(String email) =>
      LocalDatabase.getUserByEmail(email);

  // ── Hospitals ────────────────────────────────────────────────────────────
  static Future<void> saveHospital(HospitalModel hospital) =>
      LocalDatabase.insertHospital(hospital);

  static Future<List<HospitalModel>> fetchHospitals() =>
      LocalDatabase.getAllHospitals();

  // ── Utility ──────────────────────────────────────────────────────────────
  static Future<void> clearAll() => LocalDatabase.clearAll();
}