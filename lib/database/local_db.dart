import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/emergency_model.dart';
import '../models/user_model.dart';
import '../models/hospital_model.dart';

class LocalDatabase {
  static const int    _version  = 1;
  static const String _fileName = 'emergency_system.db';

  static Database? _database;

  // ── Singleton accessor ───────────────────────────────────────────────────
  static Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _fileName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ── Schema ───────────────────────────────────────────────────────────────
  static Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // Users table
    batch.execute('''
      CREATE TABLE users (
        id          TEXT PRIMARY KEY,
        name        TEXT NOT NULL,
        email       TEXT NOT NULL UNIQUE,
        password    TEXT NOT NULL,
        phone       TEXT,
        role        TEXT DEFAULT 'user',
        created_at  TEXT NOT NULL
      )
    ''');

    // Emergency requests table
    batch.execute('''
      CREATE TABLE emergency_requests (
        id                 TEXT PRIMARY KEY,
        patient_name       TEXT NOT NULL,
        emergency_type     TEXT NOT NULL,
        severity           TEXT NOT NULL,
        latitude           REAL NOT NULL,
        longitude          REAL NOT NULL,
        address            TEXT,
        status             TEXT DEFAULT 'pending',
        assigned_driver_id TEXT,
        created_at         TEXT NOT NULL
      )
    ''');

    // Hospitals table
    batch.execute('''
      CREATE TABLE hospitals (
        id           TEXT PRIMARY KEY,
        name         TEXT NOT NULL,
        type         TEXT NOT NULL,
        address      TEXT NOT NULL,
        latitude     REAL NOT NULL,
        longitude    REAL NOT NULL,
        distance_km  REAL DEFAULT 0,
        total_beds   INTEGER DEFAULT 0,
        is_open      INTEGER DEFAULT 1,
        phone        TEXT
      )
    ''');

    await batch.commit(noResult: true);
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Add migration logic here when schema changes
  }

  // ── Emergency Requests ───────────────────────────────────────────────────
  static Future<void> insertEmergency(EmergencyModel model) async {
    final db = await database;
    await db.insert(
      'emergency_requests',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<EmergencyModel>> getAllEmergencies() async {
    final db   = await database;
    final maps = await db.query(
      'emergency_requests',
      orderBy: 'created_at DESC',
    );
    return maps.map(EmergencyModel.fromMap).toList();
  }

  static Future<void> updateEmergencyStatus(
      String id, EmergencyStatus status) async {
    final db = await database;
    await db.update(
      'emergency_requests',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteEmergency(String id) async {
    final db = await database;
    await db.delete(
      'emergency_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Users ────────────────────────────────────────────────────────────────
  static Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db   = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // ── Hospitals ────────────────────────────────────────────────────────────
  static Future<void> insertHospital(HospitalModel hospital) async {
    final db = await database;
    await db.insert(
      'hospitals',
      hospital.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<HospitalModel>> getAllHospitals() async {
    final db   = await database;
    final maps = await db.query('hospitals', orderBy: 'distance_km ASC');
    return maps.map(HospitalModel.fromMap).toList();
  }

  // ── Utility ──────────────────────────────────────────────────────────────
  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Wipe all data — useful for testing / logout
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('emergency_requests');
    await db.delete('users');
    await db.delete('hospitals');
  }
}