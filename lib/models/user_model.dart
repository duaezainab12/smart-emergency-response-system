class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role; // 'user' | 'driver' | 'admin'
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone = '',
    this.role = 'user',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Copy with updated fields
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? role,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }

  /// Serialize to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Deserialize from Map (from SQLite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: (map['phone'] as String?) ?? '',
      role: (map['role'] as String?) ?? 'user',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, role: $role)';
}