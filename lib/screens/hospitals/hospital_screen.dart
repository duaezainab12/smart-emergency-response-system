import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class HospitalScreen extends StatelessWidget {
  const HospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hospitals = [
      {
        'name': 'City Hospital',
        'distance': '2.5 KM',
        'type': 'General Hospital',
        'beds': '240 beds',
        'open': true,
      },
      {
        'name': 'Emergency Care Center',
        'distance': '4.0 KM',
        'type': 'Emergency & Trauma',
        'beds': '120 beds',
        'open': true,
      },
      {
        'name': 'National Medical Complex',
        'distance': '5.2 KM',
        'type': 'Multi-Specialty',
        'beds': '400 beds',
        'open': false,
      },
      {
        'name': 'Shifa International Hospital',
        'distance': '6.8 KM',
        'type': 'Private Hospital',
        'beds': '350 beds',
        'open': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Nearby Hospitals')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search hospitals...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                fillColor: AppColors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final h = hospitals[index];
                final isOpen = h['open'] as bool;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.local_hospital_rounded,
                              color: AppColors.primary, size: 26),
                        ),
                        const SizedBox(width: 14),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(h['name'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppColors.charcoal)),
                              const SizedBox(height: 3),
                              Text(h['type'] as String,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.grey)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.bed_rounded,
                                      size: 13, color: AppColors.grey),
                                  const SizedBox(width: 4),
                                  Text(h['beds'] as String,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.grey)),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isOpen
                                          ? AppColors.success.withOpacity(0.1)
                                          : AppColors.grey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isOpen ? 'Open' : 'Closed',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isOpen
                                              ? AppColors.success
                                              : AppColors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Distance + button
                        Column(
                          children: [
                            Text(h['distance'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    fontSize: 13)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.directions_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}