import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/location_service.dart';

enum LocationStatus { idle, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  Position?      _currentPosition;
  LocationStatus _status = LocationStatus.idle;
  String         _errorMessage = '';

  // ── Getters ──────────────────────────────────────────────────────────────
  Position?      get currentPosition => _currentPosition;
  LocationStatus get status          => _status;
  String         get errorMessage    => _errorMessage;
  bool           get isLoading       => _status == LocationStatus.loading;
  bool           get hasLocation     => _currentPosition != null;

  String get formattedLocation {
    if (_currentPosition == null) return 'Location unavailable';
    final lat = _currentPosition!.latitude.toStringAsFixed(5);
    final lng = _currentPosition!.longitude.toStringAsFixed(5);
    return '$lat, $lng';
  }

  // ── Fetch location ───────────────────────────────────────────────────────
  Future<bool> fetchLocation() async {
    _status = LocationStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _currentPosition = await LocationService.getCurrentLocation();
      _status = LocationStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = LocationStatus.error;
      notifyListeners();
      return false;
    }
  }

  // ── Clear ────────────────────────────────────────────────────────────────
  void clearLocation() {
    _currentPosition = null;
    _status = LocationStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }
}