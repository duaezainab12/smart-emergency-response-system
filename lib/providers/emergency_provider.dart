import 'package:flutter/material.dart';
import '../models/emergency_model.dart';

class EmergencyProvider extends ChangeNotifier {
  final List<EmergencyModel> _requests = [];
  bool _isLoading = false;
  String? _error;

  // ── Getters ──────────────────────────────────────────────────────────────
  List<EmergencyModel> get requests        => List.unmodifiable(_requests);
  bool                 get isLoading       => _isLoading;
  String?              get error           => _error;

  List<EmergencyModel> get activeRequests =>
      _requests.where((r) =>
          r.status != EmergencyStatus.completed &&
          r.status != EmergencyStatus.cancelled).toList();

  List<EmergencyModel> get criticalRequests =>
      _requests.where((r) => r.severity == 'Critical').toList();

  int get totalDispatched =>
      _requests.where((r) =>
          r.status == EmergencyStatus.dispatched ||
          r.status == EmergencyStatus.enRoute ||
          r.status == EmergencyStatus.completed).length;

  // ── Add request ──────────────────────────────────────────────────────────
  Future<void> addRequest(EmergencyModel request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // simulate dispatch

    // Auto-assign as dispatched after a moment
    final dispatched = request.copyWith(status: EmergencyStatus.dispatched);
    _requests.insert(0, dispatched); // newest first

    _isLoading = false;
    notifyListeners();
  }

  // ── Update status ────────────────────────────────────────────────────────
  void updateStatus(String requestId, EmergencyStatus newStatus) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;
    _requests[index] = _requests[index].copyWith(status: newStatus);
    notifyListeners();
  }

  // ── Cancel request ───────────────────────────────────────────────────────
  void cancelRequest(String requestId) {
    updateStatus(requestId, EmergencyStatus.cancelled);
  }

  // ── Clear all ────────────────────────────────────────────────────────────
  void clearAll() {
    _requests.clear();
    notifyListeners();
  }
}