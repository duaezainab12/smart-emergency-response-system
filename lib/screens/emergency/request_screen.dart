import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../models/emergency_model.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/location_provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String _severity = 'Critical';
  String _emergencyType = 'Accident';
  final _nameController = TextEditingController(text: 'Patient');
  bool _isLoading = false;

  final List<Map<String, dynamic>> _severities = [
    {'label': 'Critical', 'color': AppColors.primary,
     'icon': Icons.priority_high_rounded},
    {'label': 'Moderate', 'color': AppColors.warning,
     'icon': Icons.remove_rounded},
    {'label': 'Low',      'color': AppColors.success,
     'icon': Icons.arrow_downward_rounded},
  ];

  final List<String> _emergencyTypes = [
    'Accident', 'Heart Attack', 'Stroke', 'Fire Injury',
    'Fall Injury', 'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Emergency Request'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Patient name ──────────────────────────────────────
            const Text('Patient Name',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.charcoal)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter patient name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 24),

            // ── Emergency type ────────────────────────────────────
            const Text('Emergency Type',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.charcoal)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emergencyTypes.map((type) {
                final selected = _emergencyType == type;
                return GestureDetector(
                  onTap: () => setState(() => _emergencyType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.greyLight,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Text(type,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? AppColors.white
                              : AppColors.charcoal,
                        )),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // ── Severity ──────────────────────────────────────────
            const Text('Severity Level',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.charcoal)),
            const SizedBox(height: 10),
            Row(
              children: _severities.map((s) {
                final selected = _severity == s['label'];
                final color = s['color'] as Color;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _severity = s['label']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? color : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? color : AppColors.greyLight,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Icon(s['icon'] as IconData,
                              color: selected ? AppColors.white : color,
                              size: 20),
                          const SizedBox(height: 4),
                          Text(s['label'] as String,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.charcoal)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // ── Location ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.greyLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      locationProvider.currentPosition != null
                          ? 'Lat: ${locationProvider.currentPosition!.latitude.toStringAsFixed(4)}, '
                            'Lng: ${locationProvider.currentPosition!.longitude.toStringAsFixed(4)}'
                          : 'Location not fetched yet',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.charcoal),
                    ),
                  ),
                  TextButton(
                    onPressed: () => locationProvider.fetchLocation(),
                    child: const Text('Fetch',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Submit ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        await locationProvider.fetchLocation();
                        final position =
                            locationProvider.currentPosition;
                        if (position != null && mounted) {
                          Provider.of<EmergencyProvider>(context,
                                  listen: false)
                              .addRequest(EmergencyModel(
                            patientName: _nameController.text,
                            emergencyType: _emergencyType,
                            severity: _severity,
                            latitude: position.latitude,
                            longitude: position.longitude,
                          ));
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Ambulance dispatched!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                        if (mounted) setState(() => _isLoading = false);
                      },
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.emergency_share_rounded),
                label: Text(_isLoading ? 'Dispatching...' : 'Send Emergency Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}